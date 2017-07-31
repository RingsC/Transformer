/*
*	In this file,we define some functions used in parser.
*
*
*	path:
*	include/query/parser/lex/scannGramm.h
*/
#ifndef __SCANNER_GRAMM_H__
#define __SCANNER_GRAMM_H__

#include <cstddef>
#include <types/types.h>
#include <types/nodes.h>
#include <keywords/keywords.h>

#define YYLTYPE int 
typedef void* Trans_yyscan_t ; 


//saving the tokens.
typedef union Trans_YYSTYPE	
{
	int 		ival_; 				//integer literals.
	char*		str_; 				//string literals.
	const char* keyword_;	//keywords.
} Trans_YYSTYPE ;


//for the scanner extra data. 
typedef struct Trans_yy_extra_type {
	char* 		scanbuffer_; 
	size_t 		scanbuffer_len_;
	
	const struct Transformer::ParserN::scan_keyword_t* keywords_;
	int 		keywords_num_;
	
	int			backslash_quote_;
	bool		escape_string_warning_;
	bool		standard_conforming_strings_;

	char *		literalbuffer_;		/* palloc'd expandable buffer */
	int			literallen_;		/* actual current string length */
	int			literalalloc_;	/* current allocated buffer size */	

	
	int			xcdepth_;		/* depth of nesting in slash-star comments */
	char*		dolqstart_;		/* current $foo$ quote start string */


	int32		utf16_first_part_;	

	bool		warn_on_first_escape_;
	bool		saw_non_ascii_;	

} Trans_yy_extra_type ;


typedef enum
{
	BACKSLASH_QUOTE_OFF,
	BACKSLASH_QUOTE_ON,
	BACKSLASH_QUOTE_SAFE_ENCODING
}	BackslashQuoteType;

/**************************************************************************************************************************/

extern int Trans_yylex(Trans_YYSTYPE *lvalp, YYLTYPE *llocp, Trans_yyscan_t yyscanner);
extern int Trans_scanner_errposition(int location, Trans_yyscan_t yyscanner);

#endif //__SCANNNER_GRAMM_H__ 
