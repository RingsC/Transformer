%{
/*****************************************************************************
*     the SQL grammay part.
*
******************************************************************************/
#include <parser/helper.h>
#include <types/nodes.h>

#include <parser/lex/scannerGramm.h>
#include <parser/lex/scanner.h>

#include <parser/parser.h>
#include <parser/parserGramm.h>

#define YYLLOC_DEFAULT(Current, Rhs, N) \
	do { \
		if ((N) > 0) \
			(Current) = (Rhs)[1]; \
		else \
			(Current) = (-1); \
	} while (0)

#define parser_yyerror(msg)  Trans_yyerror(msg, yyscanner)

static void TransYY_yyerror(YYLTYPE *yylloc, Trans_yyscan_t yyscanner,
						 const char *msg);
#if defined yylex
#undef yylex 
#define yylex Transformer::ParserN::Parser::TransYY_yylex
#endif
%}

%define api.pure
%pure-parser
%expect 0
%locations
%name-prefix="TransYY_yy"
%lex-param		{Trans_yyscan_t yyscanner}
%parse-param 	{Trans_yyscan_t yyscanner}
/*or using  as following, but for explicity we use the first type.
*using lex-param and parse-param explicitly.
*%param {Trans_yyscan_t yyscanner}
*/

%union{
	/*The type of bison*/
	Trans_YYSTYPE	_trans_yystype_;
	
	int 			_ival_;
	char* 			_str_;
	const char* 	_keyword_;
	bool			_boolean_;
	
	Transformer::Types::ASTNode*		_astNode_;
}


%type<_astNode_>	select_clause simple_select select_no_parens select_with_parens
%type<_astNode_>	stmtblock stmtmulti	stmt SelectStmt

%token <_str_>	IDENT FCONST SCONST BCONST XCONST Op
%token <_ival_>	ICONST PARAM
%token			TYPECAST DOT_DOT COLON_EQUALS EQUALS_GREATER
%token			LESS_EQUALS GREATER_EQUALS NOT_EQUALS

%token<_keyword_> NOT NULLS_P WITH BETWEEN IN_P LIKE ILIKE SIMILAR NOT_LA FIRST_P LAST_P NULLS_LA TIME ORDINALITY WITH_LA
					SELECT AS TEMPORARY TEMP INTO LOCAL UNLOGGED TABLE ALL GLOBAL  BY GROUP_P ORDER ABSOLUTE_P ABORT_P

%%
stmtblock:	stmtmulti
			{
				TransYY_yyget_extra(yyscanner)->parsetree_ = $1;
			}
		;
stmtmulti:	stmtmulti ';' stmt
				{
					if ($1 != NULL)
					{
						/* update length of previous stmt */
						//updateRawStmtEnd(llast_node(RawStmt, $1), @2);
					}
					if ($3 != NULL)
						$$ = $1; //lappend($1, makeRawStmt($3, @2 + 1));
					else
						$$ = $1;
				}
			| stmt
				{
					if ($1 != NULL)
						$$ = NULL; //list_make1(makeRawStmt($1, 0));
					else
						$$ = NULL;
				}
		;	
stmt: 
		SelectStmt
		|/*empty*/ { $$ = NULL;}

/*The SelectStmt definition*/
SelectStmt: select_no_parens			%prec UMINUS
			| select_with_parens		%prec UMINUS
			;

select_with_parens:
			'(' select_no_parens ')'				{ $$ = $2; }
			| '(' select_with_parens ')'			{ $$ = $2; }
		;

select_no_parens:
			select_clause 
			{
					//do somethings.
					$$ = $1;
			}
select_clause:
			simple_select							{ $$ = $1; }
		;
simple_select:
			SELECT 
				{
					Transformer::Types::SelectStmt* select = new Transformer::Types::SelectStmt ();
					$$ = select; 
				}


%%
static void
TransYY_yyerror(YYLTYPE *yylloc, Trans_yyscan_t yyscanner, const char *msg)
{
}
static void
base_yyerror(YYLTYPE *yylloc, Trans_yyscan_t yyscanner, const char *msg)
{
}

