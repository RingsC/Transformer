%top {
/************************************Start of verbatim codes.**********************************************/
/*	
	path:src/query/parser/lex/scanner.l
*/

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <memory>

#include <parser/helper.h>
#include <parser/lex/scanner.h>
#include <keywords/keywords.h>
#include <parser/parserGramm.h>

using Transformer::KeyWords::ScanKeyWord;
using Transformer::KeyWords::KeyWord;
/************************************End of verbatim codes.**********************************************/
}

%{
/**************************The Re-Definition of yy-objects.**********************************************/
//To redefine the TTTYPE, etc.
#define YYSTYPE Trans_YYSTYPE
#define YY_EXTRA_TYPE Trans_yy_extra_type *
#define SET_YYLLOC()  (*(yylloc) = yytext - yyextra->scanbuffer_)

#define yyerror(errMsg)  Trans_yyerror(errMsg, yyscanner)
#define lexer_errposition()  Trrans_scanner_errposition(*(yylloc), yyscanner)


#define ADVANCE_YYLLOC(delta)  ( *(yylloc) += (delta) )

/***********************************Global vars*********************************************************/
int			backslash_quote = BACKSLASH_QUOTE_SAFE_ENCODING;
bool		escape_string_warning = true;
bool		standard_conforming_strings = true;


#define startlit()	( yyextra->literallen_ = 0 )

/********************************Start of use-defined functions***********************************************/
static void addlit(char *ytext, int yleng, Trans_yyscan_t yyscanner);
static void addlitchar(unsigned char ychar, Trans_yyscan_t yyscanner);
static char *litbufdup(Trans_yyscan_t yyscanner);
static char *litbuf_udeescape(unsigned char escape, Trans_yyscan_t yyscanner);
static unsigned char unescape_single_char(unsigned char c, Trans_yyscan_t yyscanner);
static int	process_integer_literal(const char *token, YYSTYPE *lval);
static bool is_utf16_surrogate_first(unsigned int c);
static bool is_utf16_surrogate_second(unsigned int c);
static unsigned int surrogate_pair_to_codepoint(unsigned int first, unsigned int second);
static void addunicode(unsigned int c, yyscan_t yyscanner);
static bool check_uescapechar(unsigned char escape);
static void check_escape_warning(Trans_yyscan_t yyscanner);
static void check_string_escape_warning(unsigned char ychar, Trans_yyscan_t yyscanner);
/********************************End of use-defined functions***********************************************/
%}

%option reentrant
%option bison-bridge
%option bison-locations
%option noinput
%option noyywrap
%option noyyalloc
%option noyyrealloc
%option noyyfree
%option noinput
%option nounput
%option warn
%option nodefault
%option 8bit
%option prefix="Trans_yy"

/*************************************Start of definitions.**********************************************************/
/*the definition of some xb,etc. */
/*<xb> bit string literal*/
%x xb
/*<xc> extended C-style comments*/
%x xc
/*<xd> delimited identifiers (double-quoted identifiers)*/
%x xd
/*<xh> hexadecimal numeric string*/
%x xh
/*<xe> extended quoted strings (support backslash escape sequences)*/
%x xe
/*<xq> standard quoted strings*/
%x xq
/*<xdolq> $foo$ quoted strings*/
%x xdolq
/*<xui> quoted identifier with Unicode escapes*/
%x xui
/*<xuiend> end of a quoted identifier with Unicode escapes, UESCAPE can follow*/
%x xuiend
/*<xus> quoted string with Unicode escapes*/
%x xus
/*<xusend> end of a quoted string with Unicode escapes, UESCAPE can follow*/
%x xusend
/*<xeu> Unicode surrogate pair in extended quoted string*/
%x xeu

/*the definition of some things.*/
space			[ \t\n\r\f]
horiz_space		[ \t\f]
newline			[\n\r]
non_newline		[^\n\r]

comment			("--"{non_newline}*)

whitespace		({space}+|{comment})

/*the whithspace defintions.*/
special_whitespace		({space}+|{comment}{newline})
horiz_whitespace		({horiz_space}|{comment})
whitespace_with_newline	({horiz_whitespace}*{newline}{special_whitespace}*)

/*The quote definitions.*/
quote			'
quotestop		{quote}{whitespace}*
quotecontinue	{quote}{whitespace_with_newline}{quote}
quotefail		{quote}{whitespace}*"-"

/*The bit string definitions.*/
xbstart			[bB]{quote}
xbinside		[^']*

/*Hexadecimal number definitions.*/
xhstart			[xX]{quote}
xhinside		[^']*

/*National characters definitions.*/
xnstart			[nN]{quote}

/*Qutoted string allows '\' definitions.*/
xestart			[eE]{quote}
xeinside		[^\\']+
xeescape		[\\][^0-7]
xeoctesc		[\\][0-7]{1,3}
xehexesc		[\\]x[0-9A-Fa-f]{1,2}
xeunicode		[\\](u[0-9A-Fa-f]{4}|U[0-9A-Fa-f]{8})
xeunicodefail	[\\](u[0-9A-Fa-f]{0,3}|U[0-9A-Fa-f]{0,7})

/*xqdouble embedded quote definitions. ''''*/
xqstart			{quote}
xqdouble		{quote}{quote}
xqinside		[^']+

/*$$ styple definitions.*/
dolq_start		[A-Za-z\200-\377_]
dolq_cont		[A-Za-z\200-\377_0-9]
dolqdelim		\$({dolq_start}{dolq_cont}*)?\$
dolqfailed		\${dolq_start}{dolq_cont}*
dolqinside		[^$]+

/*double quote definitions.*/
dquote			\"
xdstart			{dquote}
xdstop			{dquote}
xddouble		{dquote}{dquote}
xdinside		[^"]+


/*somethings about Unicode, definitions. */
uescape			[uU][eE][sS][cC][aA][pP][eE]{whitespace}*{quote}[^']{quote}

uescapefail		[uU][eE][sS][cC][aA][pP][eE]{whitespace}*"-"|[uU][eE][sS][cC][aA][pP][eE]{whitespace}*{quote}[^']|[uU][eE][sS][cC][aA][pP][eE]{whitespace}*{quote}|[uU][eE][sS][cC][aA][pP][eE]{whitespace}*|[uU][eE][sS][cC][aA][pP]|[uU][eE][sS][cC][aA]|[uU][eE][sS][cC]|[uU][eE][sS]|[uU][eE]|[uU]

xuistart		[uU]&{dquote}

xusstart		[uU]&{quote}

xustop1		{uescapefail}?
xustop2		{uescape}

xufailed		[uU]&

/*C-style comment definitions.*/
xcstart			\/\*{op_chars}*
xcstop			\*+\/
xcinside		[^*/]+

digit			[0-9]
ident_start		[A-Za-z\200-\377_]
ident_cont		[A-Za-z\200-\377_0-9\$]

identifier		{ident_start}{ident_cont}*

typecast		"::"
dot_dot			\.\.
colon_equals	":="
equals_greater	"=>"
less_equals		"<="
greater_equals	">="
less_greater	"<>"
not_equals		"!="

self			[,()\[\].;\:\+\-\*\/\%\^\<\>\=]
op_chars		[\~\!\@\#\^\&\|\`\?\+\-\*\/\%\<\>\=]
operator		{op_chars}+

integer			{digit}+
decimal			(({digit}*\.{digit}+)|({digit}+\.{digit}*))
decimalfail		{digit}+\.\.
real			({integer}|{decimal})[Ee][-+]?{digit}+
realfail1		({integer}|{decimal})[Ee]
realfail2		({integer}|{decimal})[Ee][-+]

param			\${integer}

other			.
/*************************************End of definitions.**********************************************************/
%%
{whitespace}	{
					/* ignore */
				}

{xcstart}		{
					/* Set location in case of syntax error in comment */
					SET_YYLLOC();
					yyextra->xcdepth_ = 0;
					BEGIN(xc);
					/* Put back any characters past slash-star; see above */
					yyless(2);
				}

<xc>{xcstart}	{
					(yyextra->xcdepth_)++;
					/* Put back any characters past slash-star; see above */
					yyless(2);
				}

<xc>{xcstop}	{
					if (yyextra->xcdepth_ <= 0)
						BEGIN(INITIAL);
					else
						(yyextra->xcdepth_)--;
				}

<xc>{xcinside}	{
					/* ignore */
				}

<xc>{op_chars}	{
					/* ignore */
				}

<xc>\*+			{
					/* ignore */
				}

<xc><<EOF>>		{ yyerror("unterminated /* comment"); }

{xbstart}		{
					/* Binary bit type.
					 * At some point we should simply pass the string
					 * forward to the parser and label it there.
					 * In the meantime, place a leading "b" on the string
					 * to mark it for the input routine as a binary string.
					 */
					SET_YYLLOC();
					BEGIN(xb);
					startlit();
					addlitchar('b', yyscanner);
				}
<xb>{quotestop}	|
<xb>{quotefail} {
					yyless(1);
					BEGIN(INITIAL);
					yylval->str_ = litbufdup(yyscanner);
					return BCONST;
				}
<xh>{xhinside}	|
<xb>{xbinside}	{
					addlit(yytext, yyleng, yyscanner);
				}
<xh>{quotecontinue}	|
<xb>{quotecontinue}	{
					/* ignore */
				}
<xb><<EOF>>		{ yyerror("unterminated bit string literal"); }

{xhstart}		{
					/* Hexadecimal bit type.
					 * At some point we should simply pass the string
					 * forward to the parser and label it there.
					 * In the meantime, place a leading "x" on the string
					 * to mark it for the input routine as a hex string.
					 */
					SET_YYLLOC();
					BEGIN(xh);
					startlit();
					addlitchar('x', yyscanner);
				}
<xh>{quotestop}	|
<xh>{quotefail} {
					yyless(1);
					BEGIN(INITIAL);
					yylval->str_ = litbufdup(yyscanner);
					return XCONST;
				}
<xh><<EOF>>		{ yyerror("unterminated hexadecimal string literal"); }

{xnstart}		{
					/* National character.
					 * We will pass this along as a normal character string,
					 * but preceded with an internally-generated "NCHAR".
					 */
					Transformer::KeyWords::ScanKeyWord keyword;

					SET_YYLLOC();
					yyless(1);	/* eat only 'n' this time */

					keyword = KeyWord::KeyWordLookup("nchar",
												const_cast<Transformer::KeyWords::scan_keyword_t*>(yyextra->keywords_),
												yyextra->keywords_num_);
					if (keyword != NULL)
					{
						yylval->keyword_ = keyword->key_name_;
						return keyword->value_;
					}
					else
					{
						/* If NCHAR isn't a keyword, just return "n" */
						yylval->str_ = strdup("n");
						return IDENT;
					}
				}

{xqstart}		{
					yyextra->warn_on_first_escape_ = true;
					yyextra->saw_non_ascii_ = false;
					SET_YYLLOC();
					if (yyextra->standard_conforming_strings_)
						BEGIN(xq);
					else
						BEGIN(xe);
					startlit();
				}
{xestart}		{
					yyextra->warn_on_first_escape_ = false;
					yyextra->saw_non_ascii_ = false;
					SET_YYLLOC();
					BEGIN(xe);
					startlit();
				}
{xusstart}		{
					SET_YYLLOC();
					if (!yyextra->standard_conforming_strings_)
						//ereport(ERROR,
						//		(errcode(ERRCODE_FEATURE_NOT_SUPPORTED),
						//		 errmsg("unsafe use of string constant with Unicode escapes"),
						//		 errdetail("String constants with Unicode escapes cannot be used when standard_conforming_strings is off."),
						//		 lexer_errposition()));
					BEGIN(xus);
					startlit();
				}
<xq,xe>{quotestop}	|
<xq,xe>{quotefail} {
					yyless(1);
					BEGIN(INITIAL);
					/*
					 * check that the data remains valid if it might have been
					 * made invalid by unescaping any chars.
					 */
					/*
					if (yyextra->saw_non_ascii_)
						verifymbstr(yyextra->literalbuf_,
									   yyextra->literallen_,
									   false);
					*/
					yylval->str_ = litbufdup(yyscanner);
					return SCONST;
				}
<xus>{quotestop} |
<xus>{quotefail} {
					/* throw back all but the quote */
					yyless(1);
					/* xusend state looks for possible UESCAPE */
					BEGIN(xusend);
				}
<xusend>{whitespace} {
					/* stay in xusend state over whitespace */
				}
<xusend><<EOF>> |
<xusend>{other} |
<xusend>{xustop1} {
					/* no UESCAPE after the quote, throw back everything */
					yyless(0);
					BEGIN(INITIAL);
					yylval->str_ = litbuf_udeescape('\\', yyscanner);
					return SCONST;
				}
<xusend>{xustop2} {
					/* found UESCAPE after the end quote */
					BEGIN(INITIAL);
					if (!check_uescapechar(yytext[yyleng - 2]))
					{
						SET_YYLLOC();
						ADVANCE_YYLLOC(yyleng - 2);
						yyerror("invalid Unicode escape character");
					}
					yylval->str_ = litbuf_udeescape(yytext[yyleng - 2],
												   yyscanner);
					return SCONST;
				}
<xq,xe,xus>{xqdouble} {
					addlitchar('\'', yyscanner);
				}
<xq,xus>{xqinside}  {
					addlit(yytext, yyleng, yyscanner);
				}
<xe>{xeinside}  {
					addlit(yytext, yyleng, yyscanner);
				}
<xe>{xeunicode} {
					unsigned int c = strtoul(yytext + 2, NULL, 16);

					check_escape_warning(yyscanner);

					if (is_utf16_surrogate_first(c))
					{
						yyextra->utf16_first_part_ = c;
						BEGIN(xeu);
					}
					else if (is_utf16_surrogate_second(c))
						yyerror("invalid Unicode surrogate pair");
					else
						addunicode(c, yyscanner);
				}
<xeu>{xeunicode} {
					unsigned int	c = strtoul(yytext + 2, NULL, 16);

					if (!is_utf16_surrogate_second(c))
						yyerror("invalid Unicode surrogate pair");

					c = surrogate_pair_to_codepoint(yyextra->utf16_first_part_, c);

					addunicode(c, yyscanner);

					BEGIN(xe);
				}
<xeu>.			{ yyerror("invalid Unicode surrogate pair"); }
<xeu>\n			{ yyerror("invalid Unicode surrogate pair"); }
<xeu><<EOF>>	{ yyerror("invalid Unicode surrogate pair"); }
<xe,xeu>{xeunicodefail}	{
					//ereport(ERROR,
					//		(errcode(ERRCODE_INVALID_ESCAPE_SEQUENCE),
					//		 errmsg("invalid Unicode escape"),
					//		 errhint("Unicode escapes must be \\uXXXX or \\UXXXXXXXX."),
					//		 lexer_errposition()));
				}
<xe>{xeescape}  {
					if (yytext[1] == '\'')
					{
						if (yyextra->backslash_quote_ == BACKSLASH_QUOTE_OFF ||
							(yyextra->backslash_quote_ == BACKSLASH_QUOTE_SAFE_ENCODING 
							 )) 
								printf ("error...\n");
							//ereport(ERROR,
							//		(errcode(ERRCODE_NONSTANDARD_USE_OF_ESCAPE_CHARACTER),
							//		 errmsg("unsafe use of \\' in a string literal"),
							//		 errhint("Use '' to write quotes in strings. \\' is insecure in client-only encodings."),
							//		 lexer_errposition()));
					}
					check_string_escape_warning(yytext[1], yyscanner);
					addlitchar(unescape_single_char(yytext[1], yyscanner),
							   yyscanner);
				}
<xe>{xeoctesc}  {
					unsigned char c = strtoul(yytext + 1, NULL, 8);

					check_escape_warning(yyscanner);
					addlitchar(c, yyscanner);
					if (c == '\0' || IS_HIGHBIT_SET(c))
						yyextra->saw_non_ascii_ = true;
				}
<xe>{xehexesc}  {
					unsigned char c = strtoul(yytext + 2, NULL, 16);

					check_escape_warning(yyscanner);
					addlitchar(c, yyscanner);
					if (c == '\0' || IS_HIGHBIT_SET(c))
						yyextra->saw_non_ascii_ = true;
				}
<xq,xe,xus>{quotecontinue} {
					/* ignore */
				}
<xe>.			{
					/* This is only needed for \ just before EOF */
					addlitchar(yytext[0], yyscanner);
				}
<xq,xe,xus><<EOF>>		{ yyerror("unterminated quoted string"); }

{dolqdelim}		{
					SET_YYLLOC();
					yyextra->dolqstart_ = strdup(yytext);
					BEGIN(xdolq);
					startlit();
				}
{dolqfailed}	{
					SET_YYLLOC();
					/* throw back all but the initial "$" */
					yyless(1);
					/* and treat it as {other} */
					return yytext[0];
				}
<xdolq>{dolqdelim} {
					if (strcmp(yytext, yyextra->dolqstart_) == 0)
					{
						free(yyextra->dolqstart_);
						yyextra->dolqstart_ = NULL;
						BEGIN(INITIAL);
						yylval->str_ = litbufdup(yyscanner);
						return SCONST;
					}
					else
					{
						/*
						 * When we fail to match $...$ to dolqstart, transfer
						 * the $... part to the output, but put back the final
						 * $ for rescanning.  Consider $delim$...$junk$delim$
						 */
						addlit(yytext, yyleng - 1, yyscanner);
						yyless(yyleng - 1);
					}
				}
<xdolq>{dolqinside} {
					addlit(yytext, yyleng, yyscanner);
				}
<xdolq>{dolqfailed} {
					addlit(yytext, yyleng, yyscanner);
				}
<xdolq>.		{
					/* This is only needed for $ inside the quoted text */
					addlitchar(yytext[0], yyscanner);
				}
<xdolq><<EOF>>	{ yyerror("unterminated dollar-quoted string"); }

{xdstart}		{
					SET_YYLLOC();
					BEGIN(xd);
					startlit();
				}
{xuistart}		{
					SET_YYLLOC();
					BEGIN(xui);
					startlit();
				}
<xd>{xdstop}	{
					char	   *ident;

					BEGIN(INITIAL);
					if (yyextra->literallen_ == 0)
						yyerror("zero-length delimited identifier");
					ident = litbufdup(yyscanner);
					if (yyextra->literallen_ >= NAMEDATALEN)
						truncate_identifier(ident, yyextra->literallen_, true);
					yylval->str_ = ident;
					return IDENT;
				}
<xui>{dquote} {
					yyless(1);
					/* xuiend state looks for possible UESCAPE */
					BEGIN(xuiend);
				}
<xuiend>{whitespace} {
					/* stay in xuiend state over whitespace */
				}
<xuiend><<EOF>> |
<xuiend>{other} |
<xuiend>{xustop1} {
					/* no UESCAPE after the quote, throw back everything */
					char	   *ident;
					int			identlen;

					yyless(0);

					BEGIN(INITIAL);
					if (yyextra->literallen_ == 0)
						yyerror("zero-length delimited identifier");
					ident = litbuf_udeescape('\\', yyscanner);
					identlen = strlen(ident);
					if (identlen >= NAMEDATALEN)
						truncate_identifier(ident, identlen, true);
					yylval->str_ = ident;
					return IDENT;
				}
<xuiend>{xustop2}	{
					/* found UESCAPE after the end quote */
					char	   *ident;
					int			identlen;

					BEGIN(INITIAL);
					if (yyextra->literallen_ == 0)
						yyerror("zero-length delimited identifier");
					if (!check_uescapechar(yytext[yyleng - 2]))
					{
						SET_YYLLOC();
						ADVANCE_YYLLOC(yyleng - 2);
						yyerror("invalid Unicode escape character");
					}
					ident = litbuf_udeescape(yytext[yyleng - 2], yyscanner);
					identlen = strlen(ident);
					if (identlen >= NAMEDATALEN)
						truncate_identifier(ident, identlen, true);
					yylval->str_ = ident;
					return IDENT;
				}
<xd,xui>{xddouble}	{
					addlitchar('"', yyscanner);
				}
<xd,xui>{xdinside}	{
					addlit(yytext, yyleng, yyscanner);
				}
<xd,xui><<EOF>>		{ yyerror("unterminated quoted identifier"); }

{xufailed}	{
					char	   *ident;

					SET_YYLLOC();
					/* throw back all but the initial u/U */
					yyless(1);
					/* and treat it as {identifier} */
					ident = downcase_truncate_identifier(yytext, yyleng, true);
					yylval->str_ = ident;
					return IDENT;
				}

{typecast}		{
					SET_YYLLOC();
					return TYPECAST;
				}

{dot_dot}		{
					SET_YYLLOC();
					return DOT_DOT;
				}

{colon_equals}	{
					SET_YYLLOC();
					return COLON_EQUALS;
				}

{equals_greater} {
					SET_YYLLOC();
					return EQUALS_GREATER;
				}

{less_equals}	{
					SET_YYLLOC();
					return LESS_EQUALS;
				}

{greater_equals} {
					SET_YYLLOC();
					return GREATER_EQUALS;
				}

{less_greater}	{
					/* We accept both "<>" and "!=" as meaning NOT_EQUALS */
					SET_YYLLOC();
					return NOT_EQUALS;
				}

{not_equals}	{
					/* We accept both "<>" and "!=" as meaning NOT_EQUALS */
					SET_YYLLOC();
					return NOT_EQUALS;
				}

{self}			{
					SET_YYLLOC();
					return yytext[0];
				}

{operator}		{
					/*
					 * Check for embedded slash-star or dash-dash; those
					 * are comment starts, so operator must stop there.
					 * Note that slash-star or dash-dash at the first
					 * character will match a prior rule, not this one.
					 */
					int			nchars = yyleng;
					char	   *slashstar = strstr(yytext, "/*");
					char	   *dashdash = strstr(yytext, "--");

					if (slashstar && dashdash)
					{
						/* if both appear, take the first one */
						if (slashstar > dashdash)
							slashstar = dashdash;
					}
					else if (!slashstar)
						slashstar = dashdash;
					if (slashstar)
						nchars = slashstar - yytext;

					/*
					 * For SQL compatibility, '+' and '-' cannot be the
					 * last char of a multi-char operator unless the operator
					 * contains chars that are not in SQL operators.
					 * The idea is to lex '=-' as two operators, but not
					 * to forbid operator names like '?-' that could not be
					 * sequences of SQL operators.
					 */
					while (nchars > 1 &&
						   (yytext[nchars - 1] == '+' ||
							yytext[nchars - 1] == '-'))
					{
						int			ic;

						for (ic = nchars - 2; ic >= 0; ic--)
						{
							if (strchr("~!@#^&|`?%", yytext[ic]))
								break;
						}
						if (ic >= 0)
							break; /* found a char that makes it OK */
						nchars--; /* else remove the +/-, and check again */
					}

					SET_YYLLOC();

					if (nchars < yyleng)
					{
						/* Strip the unwanted chars from the token */
						yyless(nchars);
						/*
						 * If what we have left is only one char, and it's
						 * one of the characters matching "self", then
						 * return it as a character token the same way
						 * that the "self" rule would have.
						 */
						if (nchars == 1 &&
							strchr(",()[].;:+-*/%^<>=", yytext[0]))
							return yytext[0];
					}

					/*
					 * Complain if operator is too long.  Unlike the case
					 * for identifiers, we make this an error not a notice-
					 * and-truncate, because the odds are we are looking at
					 * a syntactic mistake anyway.
					 */
					if (nchars >= NAMEDATALEN)
						yyerror("operator too long");

					yylval->str_ = strdup(yytext);
					return Op;
				}

{param}			{
					SET_YYLLOC();
					yylval->ival_ = atol(yytext + 1);
					return PARAM;
				}

{integer}		{
					SET_YYLLOC();
					return process_integer_literal(yytext, yylval);
				}
{decimal}		{
					SET_YYLLOC();
					yylval->str_ = strdup(yytext);
					return FCONST;
				}
{decimalfail}	{
					/* throw back the .., and treat as integer */
					yyless(yyleng - 2);
					SET_YYLLOC();
					return process_integer_literal(yytext, yylval);
				}
{real}			{
					SET_YYLLOC();
					yylval->str_ = strdup(yytext);
					return FCONST;
				}
{realfail1}		{
					/*
					 * throw back the [Ee], and treat as {decimal}.  Note
					 * that it is possible the input is actually {integer},
					 * but since this case will almost certainly lead to a
					 * syntax error anyway, we don't bother to distinguish.
					 */
					yyless(yyleng - 1);
					SET_YYLLOC();
					yylval->str_ = strdup(yytext);
					return FCONST;
				}
{realfail2}		{
					/* throw back the [Ee][+-], and proceed as above */
					yyless(yyleng - 2);
					SET_YYLLOC();
					yylval->str_ = strdup(yytext);
					return FCONST;
				}


{identifier}	{
					Transformer::KeyWords::ScanKeyWord keyword;
					char	   *ident;

					SET_YYLLOC();

					/* Is it a keyword? */
					keyword = KeyWord::KeyWordLookup(yytext,
												const_cast<Transformer::KeyWords::scan_keyword_t*>(yyextra->keywords_),
												yyextra->keywords_num_);
					if (keyword != NULL)
					{
						yylval->keyword_ = keyword->key_name_;
						return keyword->value_;
					}

					/*
					 * No.  Convert the identifier to lower case, and truncate
					 * if necessary.
					 */
					ident = downcase_truncate_identifier(yytext, yyleng, true);
					yylval->str_ = ident;
					return IDENT;
				}

{other}			{
					SET_YYLLOC();
					return yytext[0];
				}

<<EOF>>			{
					SET_YYLLOC();
					yyterminate();
				}

%%

#undef yyextra
#define yyextra  (((struct yyguts_t *) yyscanner)->yyextra_r)

/* Likewise for a couple of other things we need. */
#undef yylloc
#define yylloc	(((struct yyguts_t *) yyscanner)->yylloc_r)
#undef yyleng
#define yyleng	(((struct yyguts_t *) yyscanner)->yyleng_r)

void
Trans_yyerror(const char *message, Trans_yyscan_t yyscanner)
{
    const char *loc = yyextra->scanbuffer_ + *yylloc;

    if (*loc == YY_END_OF_BUFFER_CHAR)
    {
        //ereport(ERROR,
        //        (errcode(ERRCODE_SYNTAX_ERROR),
        /* translator: %s is typically the translation of "syntax error" */
        //         errmsg("%s at end of input", _(message)),
        //         lexer_errposition()));
    }
    else
    {
        //ereport(ERROR,
        //        (errcode(ERRCODE_SYNTAX_ERROR),
        /* translator: first %s is typically the translation of "syntax error" */
        //         errmsg("%s at or near \"%s\"", _(message), loc),
        //         lexer_errposition()));
    }
}

int
Trans_scanner_errposition(int location, Trans_yyscan_t yyscanner)
{
    int         pos;

    if (location < 0)
        return 0;               /* no-op if location is unknown */

    /* Convert byte offset to character number */
    pos = strlen(yyextra->scanbuffer_) + 1;
    /* And pass it to the ereport mechanism */
    return (pos);
}

Trans_yyscan_t  
init_scanner (const char* parseStr, Trans_yy_extra_type* yyext, const ScanKeyWord keywords, int num_kw)
{
	size_t		slen = strlen(parseStr);
	yyscan_t	scanner;

	if (yylex_init(&scanner) != 0)
		printf("error...\n");//elog(ERROR, "yylex_init() failed: %m");

	Trans_yyset_extra(yyext, scanner);

	yyext->keywords_ = KeyWord::getScanKeyWord();
	yyext->keywords_num_ = KeyWord::getKeyWordsNumber() ;

	yyext->backslash_quote_ = backslash_quote;
	yyext->escape_string_warning_ = escape_string_warning;
	yyext->standard_conforming_strings_ = standard_conforming_strings;

	/*
	 * Make a scan buffer with special termination needed by flex.
	 */
	yyext->scanbuffer_ = (char *) malloc(slen + 2);
	yyext->scanbuffer_len_ = slen;
	memcpy(yyext->scanbuffer_, parseStr, slen);
	yyext->scanbuffer_[slen] = yyext->scanbuffer_[slen + 1] = YY_END_OF_BUFFER_CHAR;
	yy_scan_buffer(yyext->scanbuffer_, slen + 2, scanner);

	/* initialize literal buffer to a reasonable but expansible size */
	yyext->literalalloc_ = 1024;
	yyext->literalbuffer_ = (char *) malloc(yyext->literalalloc_);
	yyext->literallen_ = 0;

	return scanner;
}

void
finish_scanner(Trans_yyscan_t yyscanner)
{
	if (yyextra->scanbuffer_len_ >= 8192)
		free(yyextra->scanbuffer_);
	if (yyextra->literalalloc_ >= 8192)
		free(yyextra->literalbuffer_);
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
void*
Trans_yyrealloc(void* addr, yy_size_t bytes, Trans_yyscan_t scanner)
{
	if(addr)
		return realloc(addr, bytes) ;
	else
    	return malloc (bytes) ;
}
static void
check_escape_warning(Trans_yyscan_t yyscanner)
{
	if (yyextra->warn_on_first_escape_ && yyextra->escape_string_warning_)
		printf ("error.\n") ;
		//ereport(WARNING,
		//		(errcode(ERRCODE_NONSTANDARD_USE_OF_ESCAPE_CHARACTER),
		//		 errmsg("nonstandard use of escape in a string literal"),
		//errhint("Use the escape string syntax for escapes, e.g., E'\\r\\n'."),
		//		 lexer_errposition()));
	yyextra->warn_on_first_escape_ = false;		/* warn only once per string */
}
static void
check_string_escape_warning(unsigned char ychar, Trans_yyscan_t yyscanner)
{
	if (ychar == '\'')
	{
		if (yyextra->warn_on_first_escape_ && yyextra->escape_string_warning_)
			printf ("error.\n");
			//ereport(WARNING,
			//		(errcode(ERRCODE_NONSTANDARD_USE_OF_ESCAPE_CHARACTER),
			//		 errmsg("nonstandard use of \\' in a string literal"),
			//		 errhint("Use '' to write quotes in strings, or use the escape string syntax (E'...')."),
			//		 lexer_errposition()));
		yyextra->warn_on_first_escape_ = false;	/* warn only once per string */
	}
	else if (ychar == '\\')
	{
		if (yyextra->warn_on_first_escape_ && yyextra->escape_string_warning_)
			printf ("error.\n");
			//ereport(WARNING,
			//		(errcode(ERRCODE_NONSTANDARD_USE_OF_ESCAPE_CHARACTER),
			//		 errmsg("nonstandard use of \\\\ in a string literal"),
			//		 errhint("Use the escape string syntax for backslashes, e.g., E'\\\\'."),
			//		 lexer_errposition()));
		yyextra->warn_on_first_escape_ = false;	/* warn only once per string */
	}
	else
		check_escape_warning(yyscanner);
}

static void
addlit(char *ytext, int yleng, Trans_yyscan_t yyscanner)
{
	/* enlarge buffer if needed */
	if ((yyextra->literallen_ + yleng) >= yyextra->literalalloc_)
	{
		do
		{
			yyextra->literalalloc_ *= 2;
		} while ((yyextra->literallen_ + yleng) >= yyextra->literalalloc_);
		yyextra->literalbuffer_ = (char *) realloc(yyextra->literalbuffer_,
												yyextra->literalalloc_);
	}
	/* append new data */
	memcpy(yyextra->literalbuffer_ + yyextra->literallen_, ytext, yleng);
	yyextra->literallen_ += yleng;
}


static void
addlitchar(unsigned char ychar, Trans_yyscan_t yyscanner)
{
	/* enlarge buffer if needed */
	if ((yyextra->literallen_ + 1) >= yyextra->literalalloc_)
	{
		yyextra->literalalloc_ *= 2;
		yyextra->literalbuffer_ = (char *) realloc(yyextra->literalbuffer_,
												yyextra->literalalloc_);
	}
	/* append new data */
	yyextra->literalbuffer_[yyextra->literallen_] = ychar;
	yyextra->literallen_ += 1;
}

static char *
litbufdup(Trans_yyscan_t yyscanner)
{
	int			llen = yyextra->literallen_;

	char* new_addr = (char*) malloc(llen + 1);
	memcpy(new_addr, yyextra->literalbuffer_, llen);
	new_addr[llen] = '\0';
	return new_addr;
}

static int
process_integer_literal(const char *token, YYSTYPE *lval)
{
	long		val;
	char	   *endptr;

	errno = 0;
	val = strtol(token, &endptr, 10);
	if (*endptr != '\0' || errno == ERANGE
#ifdef HAVE_LONG_INT_64
	/* if long > 32 bits, check for overflow of int4 */
		|| val != (long) ((int32) val)
#endif
		)
	{
		/* integer too large, treat it as a float */
		lval->str_ = strdup(token);
		return FCONST;
	}
	lval->ival_ = val;
	return ICONST;
}

static unsigned int
hexval(unsigned char c)
{
	if (c >= '0' && c <= '9')
		return c - '0';
	if (c >= 'a' && c <= 'f')
		return c - 'a' + 0xA;
	if (c >= 'A' && c <= 'F')
		return c - 'A' + 0xA;
	//elog(ERROR, "invalid hexadecimal digit");
	return 0;					/* not reached */
}

static void
check_unicode_value(unsigned int c, char *loc, Trans_yyscan_t yyscanner)
{
	//if (GetDatabaseEncoding() == PG_UTF8)
	//	return;

	if (c > 0x7F)
	{
		//ADVANCE_YYLLOC(loc - yyextra->literalbuf + 3);	/* 3 for U&" */
		//yyerror("Unicode escape values cannot be used for code point values above 007F when the server encoding is not UTF8");
	}
}

static bool
is_utf16_surrogate_first(unsigned int c)
{
	return (c >= 0xD800 && c <= 0xDBFF);
}

static bool
is_utf16_surrogate_second(unsigned int c)
{
	return (c >= 0xDC00 && c <= 0xDFFF);
}

static unsigned int
surrogate_pair_to_codepoint(unsigned int first, unsigned int second)
{
	return ((first & 0x3FF) << 10) + 0x10000 + (second & 0x3FF);
}

static void
addunicode(unsigned int c, Trans_yyscan_t yyscanner)
{
	char		buf[8];

	if (c == 0 || c > 0x10FFFF)
		yyerror("invalid Unicode escape value");
	if (c > 0x7F)
	{
		//if (GetDatabaseEncoding() != PG_UTF8)
		//	yyerror("Unicode escape values cannot be used for code point values above 007F when the server encoding is not UTF8");
		yyextra->saw_non_ascii_ = true;
	}
	//unicode_to_utf8(c, (unsigned char *) buf);
	addlit(buf, strlen(buf), yyscanner);
}

static char *
litbuf_udeescape(unsigned char escape, Trans_yyscan_t yyscanner)
{
	char	   * new_addr;
	char	   *litbuf,
			   *in,
			   *out;
	unsigned int	pair_first = 0;

	/* Make literalbuf null-terminated to simplify the scanning loop */
	litbuf = yyextra->literalbuffer_;
	litbuf[yyextra->literallen_] = '\0';

	/*
	 * This relies on the subtle assumption that a UTF-8 expansion cannot be
	 * longer than its escaped representation.
	 */
	new_addr =(char*) malloc(yyextra->literallen_ + 1);

	in = litbuf;
	out = new_addr;
	while (*in)
	{
		if (in[0] == escape)
		{
			if (in[1] == escape)
			{
				if (pair_first)
				{
					ADVANCE_YYLLOC(in - litbuf + 3);	/* 3 for U&" */
					yyerror("invalid Unicode surrogate pair");
				}
				*out++ = escape;
				in += 2;
			}
			else if (isxdigit((unsigned char) in[1]) &&
					 isxdigit((unsigned char) in[2]) &&
					 isxdigit((unsigned char) in[3]) &&
					 isxdigit((unsigned char) in[4]))
			{
				unsigned int	unicode;

				unicode = (hexval(in[1]) << 12) +
					(hexval(in[2]) << 8) +
					(hexval(in[3]) << 4) +
					hexval(in[4]);
				check_unicode_value(unicode, in, yyscanner);
				if (pair_first)
				{
					if (is_utf16_surrogate_second(unicode))
					{
						unicode = surrogate_pair_to_codepoint(pair_first, unicode);
						pair_first = 0;
					}
					else
					{
						ADVANCE_YYLLOC(in - litbuf + 3);		/* 3 for U&" */
						yyerror("invalid Unicode surrogate pair");
					}
				}
				else if (is_utf16_surrogate_second(unicode))
					yyerror("invalid Unicode surrogate pair");

				if (is_utf16_surrogate_first(unicode))
					pair_first = unicode;
				else
				{
					//unicode_to_utf8(unicode, (unsigned char *) out);
					out += strlen(out);
				}
				in += 5;
			}
			else if (in[1] == '+' &&
					 isxdigit((unsigned char) in[2]) &&
					 isxdigit((unsigned char) in[3]) &&
					 isxdigit((unsigned char) in[4]) &&
					 isxdigit((unsigned char) in[5]) &&
					 isxdigit((unsigned char) in[6]) &&
					 isxdigit((unsigned char) in[7]))
			{
				unsigned int	unicode;

				unicode = (hexval(in[2]) << 20) +
					(hexval(in[3]) << 16) +
					(hexval(in[4]) << 12) +
					(hexval(in[5]) << 8) +
					(hexval(in[6]) << 4) +
					hexval(in[7]);
				check_unicode_value(unicode, in, yyscanner);
				if (pair_first)
				{
					if (is_utf16_surrogate_second(unicode))
					{
						unicode = surrogate_pair_to_codepoint(pair_first, unicode);
						pair_first = 0;
					}
					else
					{
						ADVANCE_YYLLOC(in - litbuf + 3);		/* 3 for U&" */
						yyerror("invalid Unicode surrogate pair");
					}
				}
				else if (is_utf16_surrogate_second(unicode))
					yyerror("invalid Unicode surrogate pair");

				if (is_utf16_surrogate_first(unicode))
					pair_first = unicode;
				else
				{
					//unicode_to_utf8(unicode, (unsigned char *) out);
					out += strlen(out);
				}
				in += 8;
			}
			else
			{
				ADVANCE_YYLLOC(in - litbuf + 3);		/* 3 for U&" */
				yyerror("invalid Unicode escape value");
			}
		}
		else
		{
			if (pair_first)
			{
				ADVANCE_YYLLOC(in - litbuf + 3);		/* 3 for U&" */
				yyerror("invalid Unicode surrogate pair");
			}
			*out++ = *in++;
		}
	}

	/* unfinished surrogate pair? */
	if (pair_first)
	{
		ADVANCE_YYLLOC(in - litbuf + 3);				/* 3 for U&" */
		yyerror("invalid Unicode surrogate pair");
	}

	*out = '\0';

	/*
	 * We could skip pg_verifymbstr if we didn't process any non-7-bit-ASCII
	 * codes; but it's probably not worth the trouble, since this isn't likely
	 * to be a performance-critical path.
	 */
	//pg_verifymbstr(new_addr, out - new_addr, false);
	return new_addr;
}
static bool
check_uescapechar(unsigned char escape)
{
	if (isxdigit(escape)
		|| escape == '+'
		|| escape == '\''
		|| escape == '"'
		|| scanner_isspace(escape))
	{
		return false;
	}
	else
		return true;
}

static unsigned char
unescape_single_char(unsigned char c, Trans_yyscan_t yyscanner)
{
	switch (c)
	{
		case 'b':
			return '\b';
		case 'f':
			return '\f';
		case 'n':
			return '\n';
		case 'r':
			return '\r';
		case 't':
			return '\t';
		default:
			/* check for backslash followed by non-7-bit-ASCII */
			if (c == '\0' || IS_HIGHBIT_SET(c))
				yyextra->saw_non_ascii_ = true;

			return c;
	}
}

