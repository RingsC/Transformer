/*********************
*
* path:
*	src/query/parser/parser.cpp
*/

#include "parser/lex/scanner.h"
#include "parser/parser.h"

namespace Transformer{
namespace ParserN{

using namespace Transformer::KeyWords ;

Parser::Parser()
{

}
Parser::~Parser()
{

}

Transformer::Types::ASTNode* 
Parser::raw_parser(const char* str)
{
	Trans_yyscan_t yyscanner;
	base_yy_extra_type base_yy;	

	yyscanner = init_scanner(str, &base_yy.trans_yy_extra_, KeyWord::getScanKeyWord(), 
															KeyWord::getKeyWordsNumber());	
	
	base_yy.have_lookahead_ = false; 
	//do gramm parser.
			

	finish_scanner (yyscanner) ;	
	return (Transformer::Types::ASTNode*) NULL; 
}

}//ParserN.
}//Transformer.
