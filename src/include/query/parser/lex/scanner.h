/*
*	In this file,we define some functions used in parser.
*
*
*	path:
*	include/query/parser/lex/scanner.h
*/
#ifndef __SCANNER_H__
#define __SCANNER_H__

#include <cstddef>
#include "types/types.h"
#include "types/nodes.h"
#include "keywords/keywords.h"

#define YYLTYPE int 
typedef void* Trans_yyscan_t ; 

//saving the tokens.
typedef union Trans_YYSTYPE	
{
	int 		ival_; 				//integer literals.
	char*		str_; 				//string literals.
	const char* keyword_;	//keywords.
} Trans_YYSTYPE ;


//for the core parser-scanner. 
typedef struct Trans_yy_extra_type {
	char* 		scanbuffer_; 
	size_t 		scanbuffer_len_;
	
	const struct ScanKeyWord_T* \
				keywords_;
	int 		keywords_num_;
	
	int			backslash_quote_;
	bool		escape_string_warning_;
	bool		standard_conforming_strings_;

	char *		literalbuf_;		/* palloc'd expandable buffer */
	int			literallen_;		/* actual current string length */
	int			literalalloc_;	/* current allocated buffer size */	

	
	int			xcdepth_;		/* depth of nesting in slash-star comments */
	char*		dolqstart_;		/* current $foo$ quote start string */


	int32		utf16_first_part_;	

	bool		warn_on_first_escape_;
	bool		saw_non_ascii_;	

} Trans_yy_extra_type ;

typedef struct base_yy_extra_type
{
	Trans_yy_extra_type			trans_yy_extra_;
	
	bool		have_lookahead_;		 /* is lookahead info valid? */
	int			lookahead_token_;		/* one-token lookahead */
	Trans_YYSTYPE \
				lookahead_yylval_;		/* yylval for lookahead token */
	YYLTYPE		lookahead_yylloc_;		/* yylloc for lookahead token */
	char*       lookahead_end_;			/* end of current token */
	char		lookahead_hold_char_;	/* to be put back at *lookahead_end */ 

	Transformer::Types::ASTNode*    parsetree_;				//final parse tree. 
} base_yy_extra_type;


/**************************************************************************************************************************/
//for the scanner.
extern Trans_yyscan_t  
		init_scanner (const char* parseStr, Trans_yy_extra_type* yyext, const Transformer::KeyWords::ScanKeyWord keywords, int num_kw);
extern void
		finish_scanner(Trans_yyscan_t scanner); 		   

extern int Trans_yylex(Trans_YYSTYPE *lvalp, YYLTYPE *llocp, Trans_yyscan_t yyscanner);

#endif //__SCANNNER_H__ 
