%top {
/*The include files here*/

#include <stdio.h>
#include "scanner.h"
#include "keywords/keywords.h"

using namespace Transformer::Lex;
using Transformer::KeyWords::ScanKeyWord;
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

Trans_yyscan_t  init_scanner (const char* parseStr, Trans_yy_extra_type* yyext, const ScanKeyWord* keywords, int num_kw)
{
	Trans_yyscan_t retVal(NULL); 
	printf ("in init_scanner functions...\n") ;
	return retVal;
}

