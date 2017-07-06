/*
in this file,we define some functions used in parser.
*/
#ifndef __SCANNER_H__
#define __SCANNER_H__

#include "types/types.h"

namespace Transformer{
namespace Lex {

class ScannKeyWord ;

typedef union YYSTYPE
{
	int ival;
	char *str; 
	const char* keyword;
} YYSTYPE ;


//for the core parser-scanner. 
typedef struct Trans_yy_extra_type {

} Trans_yy_extra_type ;

#define YYLTYPE int 
/**************************************************************************************************************************/
//for the scanner.
typedef void* Trans_yyscan_t ; 

//the keywords used by scanner, lex.

extern Trans_yyscan_t  init_scanner (const char* parseStr, Trans_yy_extra_type* yyext, const ScannKeyWord* keywords, int num_kw);


}//namespace lex
}//namespace transformer.

#endif //__SCANNNER_H__ 
