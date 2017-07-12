%top {
/*The include files here*/
/*path:src/query/parser/lex/scanner.l*/

#include <stdio.h>
#include <stdlib.h>
#include <memory>

#include "scanner.h"
#include "keywords.h"
//to include the scankey

using Transformer::KeyWords::ScanKeyWord;


//To redefine the TTTYPE, etc.
#define YYSTYPE Trans_YYSTYPE
#define YY_EXTRA_TYPE Trans_yy_extra_type *

}

%{

static void use_funct () 
{
	//Here use function. 

	return ; 
}
%}

%option reentrant
%option bison-bridge
%option bison-locations
%option noinput
%option noyywrap
%option noyyfree
%option noyyalloc
%option prefix="Trans_yy"


/*the definition of some things.*/
space			[ \t\n\r\f]
horiz_space		[ \t\f]
newline			[\n\r]
non_newline		[^\n\r]

comment			("--"{non_newline}*)

whitespace		({space}+|{comment})

%%

{whitespace}	{
					/* ignore */
				}


%%
Trans_yyscan_t  
init_scanner (const char* parseStr, Trans_yy_extra_type* yyext, const ScanKeyWord keywords, int num_kw)
{
	Trans_yyscan_t retVal(NULL); 
	printf ("in init_scanner functions...\n") ;
	return retVal;
}

void
finish_scanner(Trans_yyscan_t scanner)
{
	return ;
}
void 
Trans_yyfree(void* ptr, Trans_yyscan_t yyscanner)
{//here, we will use memory contxt to replace this.
	if (ptr)
		free(ptr) ;
}
void*
Trans_yyalloc(yy_size_t bytes, Trans_yyscan_t scanner)
{
	return malloc (bytes) ;
}
