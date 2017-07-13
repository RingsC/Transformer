/*********************
* A parser to generate a AST tree.
* path:
*	src/query/parser/parser.cpp
*/

#include <parser/lex/scanner.h>
#include <parser/parser.h>
#include <parser/parserGramm.h>

namespace Transformer{
namespace ParserN{

using namespace Transformer::KeyWords ;

Parser::Parser()
{

}
Parser::~Parser()
{

}

int
Parser::TransYY_yylex(YYSTYPE *lvalp, YYLTYPE *llocp, Trans_yyscan_t yyscanner)
{
    return 0;
}

Transformer::Types::ASTNode* 
Parser::raw_parser(const char* str)
{
	Trans_yyscan_t lex_scanner;
	TransYY_yy_extra_type bison_yy;	

	lex_scanner = init_scanner(str, &bison_yy.trans_yy_extra_, KeyWord::getScanKeyWord(), 
															KeyWord::getKeyWordsNumber());	
	
	bison_yy.have_lookahead_ = false; 
	//do gramm parser.
			

	finish_scanner (lex_scanner) ;	
	return (Transformer::Types::ASTNode*) NULL; 
}

}//ParserN.
}//Transformer.
