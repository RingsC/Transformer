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
#include <parser/lex/scannerGramm.h>
#include <keywords/keywords.h>
#include <parser/parserGramm.h>
#include <lex/lexical.h>

using Transformer::KeyWords::ScanKeyWord;
using Transformer::KeyWords::KeyWord;
/************************************End of verbatim codes.**********************************************/
}

%{
/**************************The Re-Definition of yy-objects.**********************************************/
//To redefine the TTTYPE, etc.
#define YYSTYPE Trans_YYSTYPE
#define SET_YYLLOC()  (*(yylloc) = yytext - yyextra->scanbuffer_)
#define yyerror(errMsg)  Transformer::Lexical::Lex::lex_yyerror(errMsg, yyscanner, yyextra, yylloc)
#define lexer_errposition()  Transformer::Lexical::Lex::lex_scanner_errposition (*(yylloc), yyscanner)
/***********************************Global vars*********************************************************/
int			backslash_quote = BACKSLASH_QUOTE_SAFE_ENCODING;
bool		escape_string_warning = true;
bool		standard_conforming_strings = true;
#define startlit()	( yyextra->literallen_ = 0 )

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
%option extra-type="Trans_yy_extra_type *"

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
					Transformer::Lexical::LexHelper::addlitchar('b', yyscanner, yyextra);
				}
<xb>{quotestop}	|
<xb>{quotefail} {
					yyless(1);
					BEGIN(INITIAL);
					yylval->str_ = Transformer::Lexical::LexHelper::litbufdup(yyscanner, yyextra);
					return BCONST;
				}
<xh>{xhinside}	|
<xb>{xbinside}	{
					Transformer::Lexical::LexHelper::addlit(yytext, yyleng, yyscanner, yyextra);
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
					Transformer::Lexical::LexHelper::addlitchar('x', yyscanner, yyextra);
				}
<xh>{quotestop}	|
<xh>{quotefail} {
					yyless(1);
					BEGIN(INITIAL);
					yylval->str_ = Transformer::Lexical::LexHelper::litbufdup(yyscanner, yyextra);
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
					yylval->str_ = Transformer::Lexical::LexHelper::litbufdup(yyscanner, yyextra);
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
					yylval->str_ = Transformer::Lexical::LexHelper::litbuf_udeescape('\\', yyscanner, yyextra, yylloc);
					return SCONST;
				}
<xusend>{xustop2} {
					/* found UESCAPE after the end quote */
					BEGIN(INITIAL);
					if (!Transformer::Lexical::LexHelper::check_uescapechar(yytext[yyleng - 2], yyscanner, yyextra))
					{
						SET_YYLLOC();
						//ADVANCE_YYLLOC(yyleng - 2);
						*(yylloc) +=(yyleng-2) ;
						yyerror("invalid Unicode escape character");
					}
					yylval->str_ = Transformer::Lexical::LexHelper::litbuf_udeescape(yytext[yyleng - 2],
												   yyscanner, yyextra, yylloc);
					return SCONST;
				}
<xq,xe,xus>{xqdouble} {
					Transformer::Lexical::LexHelper::addlitchar('\'', yyscanner, yyextra);
				}
<xq,xus>{xqinside}  {
					Transformer::Lexical::LexHelper::addlit(yytext, yyleng, yyscanner, yyextra);
				}
<xe>{xeinside}  {
					Transformer::Lexical::LexHelper::addlit(yytext, yyleng, yyscanner, yyextra);
				}
<xe>{xeunicode} {
					unsigned int c = strtoul(yytext + 2, NULL, 16);

					Transformer::Lexical::LexHelper::check_escape_warning(yyscanner, yyextra);

					if (Transformer::Lexical::LexHelper::is_utf16_surrogate_first(c, yyscanner, yyextra))
					{
						yyextra->utf16_first_part_ = c;
						BEGIN(xeu);
					}
					else if (Transformer::Lexical::LexHelper::is_utf16_surrogate_second(c, yyscanner, yyextra))
						yyerror("invalid Unicode surrogate pair");
					else
						Transformer::Lexical::LexHelper::addunicode(c, yyscanner, yyextra);
				}
<xeu>{xeunicode} {
					unsigned int	c = strtoul(yytext + 2, NULL, 16);

					if (!Transformer::Lexical::LexHelper::is_utf16_surrogate_second(c, yyscanner, yyextra))
						yyerror("invalid Unicode surrogate pair");

					c = Transformer::Lexical::LexHelper::surrogate_pair_to_codepoint(yyextra->utf16_first_part_, c, yyscanner, yyextra);

					Transformer::Lexical::LexHelper::addunicode(c, yyscanner, yyextra);

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
					Transformer::Lexical::LexHelper::check_string_escape_warning(yytext[1], yyscanner, yyextra);
					Transformer::Lexical::LexHelper::addlitchar(Transformer::Lexical::LexHelper::unescape_single_char(yytext[1], yyscanner, yyextra),
							   yyscanner, yyextra);
				}
<xe>{xeoctesc}  {
					unsigned char c = strtoul(yytext + 1, NULL, 8);

					Transformer::Lexical::LexHelper::check_escape_warning(yyscanner, yyextra);
					Transformer::Lexical::LexHelper::addlitchar(c, yyscanner, yyextra);
					if (c == '\0' || IS_HIGHBIT_SET(c))
						yyextra->saw_non_ascii_ = true;
				}
<xe>{xehexesc}  {
					unsigned char c = strtoul(yytext + 2, NULL, 16);

					Transformer::Lexical::LexHelper::check_escape_warning(yyscanner, yyextra);
					Transformer::Lexical::LexHelper::addlitchar(c, yyscanner, yyextra);
					if (c == '\0' || IS_HIGHBIT_SET(c))
						yyextra->saw_non_ascii_ = true;
				}
<xq,xe,xus>{quotecontinue} {
					/* ignore */
				}
<xe>.			{
					/* This is only needed for \ just before EOF */
					Transformer::Lexical::LexHelper::addlitchar(yytext[0], yyscanner, yyextra);
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
						yylval->str_ = Transformer::Lexical::LexHelper::litbufdup(yyscanner, yyextra);
						return SCONST;
					}
					else
					{
						/*
						 * When we fail to match $...$ to dolqstart, transfer
						 * the $... part to the output, but put back the final
						 * $ for rescanning.  Consider $delim$...$junk$delim$
						 */
						Transformer::Lexical::LexHelper::addlit(yytext, yyleng - 1, yyscanner, yyextra);
						yyless(yyleng - 1);
					}
				}
<xdolq>{dolqinside} {
					Transformer::Lexical::LexHelper::addlit(yytext, yyleng, yyscanner, yyextra);
				}
<xdolq>{dolqfailed} {
					Transformer::Lexical::LexHelper::addlit(yytext, yyleng, yyscanner, yyextra);
				}
<xdolq>.		{
					/* This is only needed for $ inside the quoted text */
					Transformer::Lexical::LexHelper::addlitchar(yytext[0], yyscanner, yyextra);
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
					ident = Transformer::Lexical::LexHelper::litbufdup(yyscanner, yyextra);
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
					ident = Transformer::Lexical::LexHelper::litbuf_udeescape('\\', yyscanner, yyextra, yylloc);
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
					if (!Transformer::Lexical::LexHelper::check_uescapechar(yytext[yyleng - 2], yyscanner, yyextra))
					{
						SET_YYLLOC();
						//ADVANCE_YYLLOC(yyleng - 2);
						*(yylloc)+=(yyleng - 2);
						yyerror("invalid Unicode escape character");
					}
					ident = Transformer::Lexical::LexHelper::litbuf_udeescape(yytext[yyleng - 2], yyscanner, yyextra, yylloc);
					identlen = strlen(ident);
					if (identlen >= NAMEDATALEN)
						truncate_identifier(ident, identlen, true);
					yylval->str_ = ident;
					return IDENT;
				}
<xd,xui>{xddouble}	{
					Transformer::Lexical::LexHelper::addlitchar('"', yyscanner, yyextra);
				}
<xd,xui>{xdinside}	{
					Transformer::Lexical::LexHelper::addlit(yytext, yyleng, yyscanner, yyextra);
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
					return Transformer::Lexical::LexHelper::process_integer_literal(yytext, yylval, yyscanner, yyextra);
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
					return Transformer::Lexical::LexHelper::process_integer_literal(yytext, yylval, yyscanner, yyextra);
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
