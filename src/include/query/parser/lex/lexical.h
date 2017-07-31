/*
* the definition of somthings used by lex scanner.
* path: parse/lex/lexical.h
*/
#ifndef __LEXICAL_H__
#define __LEXICAL_H__

#include <system/system.h>
#include <types/types.h>
#include <lex/scannerGramm.h>
#include <keywords/keywords.h>

namespace Transformer{
namespace Lexical {


#define YY_END_OF_BUFFER_CHAR 0

using Transformer::ParserN::ScanKeyWord ;
using Transformer::ParserN::KeyWord;
using Transformer::Types::NonCopyable ;

extern int Trans_yylex_init(Trans_yyscan_t* ptr_yy_globals );

class TRANS_EXPORT Lex : public Transformer::Types::NonCopyable {
public:
	Lex ();
	virtual ~Lex() ;
	static Trans_yyscan_t
	init_scanner (const char* parseStr, Trans_yy_extra_type* yyext, const ScanKeyWord keywords, int num_kw) ; 
	static void 
	finish_scanner(Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr) ;

	static void lex_yyerror(const char *message, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr, YYLTYPE* lloc);
	static int lex_scanner_errposition(int location, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr, YYLTYPE* lloc);

	static int backslash_quote  ;
	static bool escape_string_warning ;
	static bool standard_conforming_strings ;	
} ;

class TRANS_EXPORT LexHelper : public Transformer::Types::NonCopyable {
public:
	LexHelper() ;
	virtual ~LexHelper () ;

public:
	static unsigned int hexval (unsigned char c);	
	static void addlit(char *ytext, int yleng, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr);
	static void addlitchar(unsigned char ychar, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr);
	static char *litbufdup(Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr);	
	static char *litbuf_udeescape(unsigned char escape, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr, YYLTYPE* lloc);
	static unsigned char unescape_single_char(unsigned char c, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr);
	static int  process_integer_literal(const char *token, Trans_YYSTYPE *lval, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr);
	static bool is_utf16_surrogate_first(unsigned int c,Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr);
	static bool is_utf16_surrogate_second(unsigned int c, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr);
	static unsigned int surrogate_pair_to_codepoint(unsigned int first, unsigned int second, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr);	
	static void addunicode(unsigned int c, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr);	
	static bool check_uescapechar(unsigned char escape, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr);
	static void check_escape_warning(Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr);
	static void check_string_escape_warning(unsigned char ychar, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr);
	static void check_unicode_value(unsigned int c, char *loc, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr) ;

} ;

} //namespace Lexical
} //namespace Transformer

#endif 
