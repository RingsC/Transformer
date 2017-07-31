/*********************
* A parser to generate a AST tree.
* path:
*	src/query/parser/parser.cpp
*/

#include <parser/lex/scannerGramm.h>
#include <parser/parser.h>
#include <parser/parserGramm.h>
#include <parser/lex/lexical.h>

namespace Transformer{
namespace ParserN{

using namespace Transformer::Lexical; 

Parser::Parser()
{

}
Parser::~Parser()
{

}
void 
Parser::init_parser(TransYY_yy_extra_type* yy_extra_data) 
{
	yy_extra_data->parsetree_ = NULL ; 
}

int
Parser::TransYY_yylex(YYSTYPE *lvalp, YYLTYPE *llocp, Trans_yyscan_t yyscanner)
{
	TransYY_yy_extra_type *yyextra = TransYY_yyget_extra(yyscanner);
	int			cur_token;
	int			next_token;
	int			cur_token_length;
	YYLTYPE		cur_yylloc;

	/* Get next token --- we might already have it */
	if (yyextra->have_lookahead_)
	{
		cur_token = yyextra->lookahead_token_;
		lvalp->_trans_yystype_ = yyextra->lookahead_yylval_;
		*llocp = yyextra->lookahead_yylloc_;
		*(yyextra->lookahead_end_) = yyextra->lookahead_hold_char_;
		yyextra->have_lookahead_ = false;
	}
	else
		cur_token = Trans_yylex(&(lvalp->_trans_yystype_), llocp, yyscanner);

	/*
	 * If this token isn't one that requires lookahead, just return it.  If it
	 * does, determine the token length.  (We could get that via strlen(), but
	 * since we have such a small set of possibilities, hardwiring seems
	 * feasible and more efficient.)
	 */
	switch (cur_token)
	{
		case NOT:
			cur_token_length = 3;
			break;
		case NULLS_P:
			cur_token_length = 5;
			break;
		case WITH:
			cur_token_length = 4;
			break;
		default:
			return cur_token;
	}

	/*
	 * Identify end+1 of current token.  core_yylex() has temporarily stored a
	 * '\0' here, and will undo that when we call it again.  We need to redo
	 * it to fully revert the lookahead call for error reporting purposes.
	 */
	yyextra->lookahead_end_ = yyextra->trans_yy_extra_.scanbuffer_ +
		*llocp + cur_token_length;
	TRANS_ASSERT(*(yyextra->lookahead_end_) == '\0');

	/*
	 * Save and restore *llocp around the call.  It might look like we could
	 * avoid this by just passing &lookahead_yylloc to core_yylex(), but that
	 * does not work because flex actually holds onto the last-passed pointer
	 * internally, and will use that for error reporting.  We need any error
	 * reports to point to the current token, not the next one.
	 */
	cur_yylloc = *llocp;

	/* Get next token, saving outputs into lookahead variables */
	next_token = Trans_yylex(&(yyextra->lookahead_yylval_), llocp, yyscanner);
	yyextra->lookahead_token_ = next_token;
	yyextra->lookahead_yylloc_ = *llocp;

	*llocp = cur_yylloc;

	/* Now revert the un-truncation of the current token */
	yyextra->lookahead_hold_char_ = *(yyextra->lookahead_end_);
	*(yyextra->lookahead_end_) = '\0';

	yyextra->have_lookahead_ = true;

	/* Replace cur_token if needed, based on lookahead */
	switch (cur_token)
	{
		case NOT:
			/* Replace NOT by NOT_LA if it's followed by BETWEEN, IN, etc */
			switch (next_token)
			{
				case BETWEEN:
				case IN_P:
				case LIKE:
				case ILIKE:
				case SIMILAR:
					cur_token = NOT_LA;
					break;
			}
			break;

		case NULLS_P:
			/* Replace NULLS_P by NULLS_LA if it's followed by FIRST or LAST */
			switch (next_token)
			{
				case FIRST_P:
				case LAST_P:
					cur_token = NULLS_LA;
					break;
			}
			break;

		case WITH:
			/* Replace WITH by WITH_LA if it's followed by TIME or ORDINALITY */
			switch (next_token)
			{
				case TIME:
				case ORDINALITY:
					cur_token = WITH_LA;
					break;
			}
			break;
	}

	return cur_token;
}

Transformer::Types::ASTNode* 
Parser::raw_parser(const char* str)
{
	Trans_yyscan_t lex_scanner;
	TransYY_yy_extra_type bison_yy;	

	lex_scanner = Lex::init_scanner(str, &bison_yy.trans_yy_extra_, KeyWord::getScanKeyWord(), 
															KeyWord::getKeyWordsNumber());	
	
	bison_yy.have_lookahead_ = false; 
	//do gramm parser.
	init_parser(&bison_yy);
	int yyresult = TransYY_yyparse(lex_scanner);	
	
	Lex::finish_scanner (lex_scanner, &bison_yy.trans_yy_extra_) ;	
	return (Transformer::Types::ASTNode*) NULL; 
}

}//ParserN.
}//Transformer.
