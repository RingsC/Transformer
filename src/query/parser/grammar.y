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
	Transformer::Types::TargetList*     _targetList_;
	Transformer::Types::TableEntryList* _tableList_;
	Transformer::Types::FromStmt* 	    _fromStmt_;
	Transformer::Types::WhereStmt*      _whereStmt_;
	Transformer::Types::Expr			_expr_;
	Transformer::Types::AggrateStmt*    _aggrStmt_;
}


%type<_astNode_>	select_clause simple_select select_no_parens select_with_parens
%type<_astNode_>	stmtblock stmtmulti	stmt SelectStmt
%type<_astNode_>    target_entry table_entry

%type<_targetList_> target_list_opt target_list_stmt

%type<_tableList_> from_list 
%type<_fromStmt_>  from_stmt 
%type<_whereStmt_> where_stmt
%type <_aggrStmt_> aggr_stmt groupby_stmt having_Stmt orderby_stmt limit_stmt 

%token <_str_>	IDENT FCONST SCONST BCONST XCONST Op
%token <_ival_>	ICONST PARAM
%token			TYPECAST DOT_DOT COLON_EQUALS EQUALS_GREATER
%token			LESS_EQUALS GREATER_EQUALS NOT_EQUALS

%token<_keyword_> NOT NULLS_P WITH BETWEEN IN_P LIKE ILIKE SIMILAR NOT_LA FIRST_P LAST_P NULLS_LA TIME ORDINALITY WITH_LA
					AS TEMPORARY TEMP INTO LOCAL UNLOGGED TABLE ALL GLOBAL  BY GROUP_P ORDER ABSOLUTE_P ABORT_P
%token<_keyword_> SELECT FROM WHERE ORDER BY HAVING GROUP LIMIT 
				
%%
stmtblock:	stmtmulti
													{
														TransYY_yyget_extra(yyscanner)->parsetree_ = $1;
													}
			;
stmtmulti:	stmtmulti ';' stmt
													{
														$$ = $1;
													}
			| stmt
													{
														$$ = $1;
													}
			;	
stmt: 
			SelectStmt 
			|/*empty*/ 								{ $$ = NULL;}

/*The SelectStmt definition*/
SelectStmt: select_no_parens						%prec UMINUS
			| select_with_parens					%prec UMINUS
			;

select_with_parens:
			'(' select_no_parens ')'				{ $$ = $2; }
			| '(' select_with_parens ')'			{ $$ = $2; }
			;

select_no_parens:
			select_clause 
													{
														$$ = $1;
													}
			;
select_clause:
			simple_select							{ $$ = $1; }
			;
simple_select:
			SELECT target_list_opt from_stmt where_stmt aggr_stmt		
													{ //the new operator, it will be replaced by new memory allocator placement.
														Transformer::Types::SelectStmt* select = new Transformer::Types::SelectStmt ();
														select->setTargetList ($2);
														select->setFromStmt($3);
														select->setWhereStmt($4);
														$$ = select; 
													}
			;
target_list_opt: target_list_stmt					{$$ = $1;}
			|/*empty*/								{$$ = (Transformer::Types::TargetList*)NULL;}	
			;
	
target_list_stmt:
			target_list_stmt ',' target_entry		{
														Transformer::Types::TargetList* target(NULL); 
														if ($1) {
															target = $1; 
															target->mergeEntries ($3) ;
														} else {
															target = new Transformer::Types::TargetList () ;
															target->addEntry ($3) ;
														}
														$$ = target; 
													}	
			| target_entry							{
														Transformer::Types::TargetList* target = new Transformer::Types::TargetList (); 
														target->addEntry ($1) ;	
														$$ = target; 	
													}
				;
target_entry:	
			IDENT									{
														Transformer::Types::TargetEntry* targetEntry = new Transformer::Types::TargetEntry ($1);
														$$ = targetEntry;	
													}
			|	'*'									{
														Transformer::Types::TargetEntry* targetEntry = new Transformer::Types::TargetEntry ("*");
														$$ = targetEntry;	
													}
			;
				
from_stmt:	FROM from_list							{
														Transformer::Types::FromStmt* from = new Transformer::Types::FromStmt(); 
														from->setTableEntryList ($2);	
														$$ = from; 	
													}
			|/**/									{
														$$ = NULL ; 
													}
			;


from_list:	from_list ',' table_entry				{
														Transformer::Types::TableEntryList* tableList = NULL;
														if ($1) {	
															tableList = $1; 
														} else 
															tableList = new Transformer::Types::TableEntryList ();
														tableList->addTableEntry($3) ;
														$$ = tableList; 		
													}
			| table_entry							{
														Transformer::Types::TableEntryList* tableList = new Transformer::Types::TableEntryList ();
														tableList->addTableEntry ($1);
														$$ = tableList; 
													}
			;
table_entry : IDENT									{
														Transformer::Types::TableEntry* table = new Transformer::Types::TableEntry ($1) ;
														$$ = table; 
													}
			| IDENT '.' IDENT						{ //format:database.table

													}
			| IDENT '.' IDENT '.' IDENT 			{//format: schema.database.table
														
													}
			;

where_stmt : WHERE condition_stmt 
													{
														Transformer::Types::WhereStmt* where = new Transformer::Types::WhereStmt (); 
														$$ = where; 				
													}
			|/*without where stmt*/					{ $$ = NULL ;}
			;
condition_stmt: 									{ $$ = NULL; }

groupby_stmt: GROUP BY IDENT						{
															
													} 
				
%%
/*
	the error report. 
*/
static void
TransYY_yyerror(YYLTYPE *yylloc, Trans_yyscan_t yyscanner, const char *msg)
{
}
static void
base_yyerror(YYLTYPE *yylloc, Trans_yyscan_t yyscanner, const char *msg)
{
}

