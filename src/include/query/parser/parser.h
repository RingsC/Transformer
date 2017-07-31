/*
*  A new query engines for Transformer.
*  path:query/parser/parser.h
*/

#ifndef __PARSER_H__
#define __PARSER_H__

#include <types/types.h>
#include <types/nodes.h>
#include <system/system.h>
#include <parser/lex/scannerGramm.h>
#include <parser/grammar.h>
#include <parser/parserGramm.h>

namespace Transformer{
namespace ParserN{

class TRANS_EXPORT Parser : public Transformer::Types::NonCopyable {
public:
	Parser () ;
	~Parser() ;
	virtual Transformer::Types::ASTNode* raw_parser(const char* str); 	
    virtual void init_parser(TransYY_yy_extra_type* yy_extra_data) ;

	static int TransYY_yylex(YYSTYPE *lvalp, YYLTYPE *llocp, Trans_yyscan_t yyscanner) ;
} ;


}//namespace Parser. 
}//namespace Transformer.


#endif   /* __PARSER_H__ */
