/*
	the impl of functions used by lex scanner. 
	path: parser/lex/lexical.cpp
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>
#include <lex/lexical.h>
#include <lex/scanner_lex.h>
#include <parser/parserGramm.h>
#include <parser/helper.h>

namespace Transformer {
namespace Lexical {

Lex::Lex () 
{
}

Lex::~Lex ()
{
}


Trans_yyscan_t
Lex::init_scanner (const char* parseStr, Trans_yy_extra_type* yyext, const ScanKeyWord keywords, int num_kw)
{
    size_t      slen = strlen(parseStr);
    yyscan_t    scanner;

    if (Trans_yylex_init(&scanner) != 0)
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
    Trans_yy_scan_buffer(yyext->scanbuffer_, slen + 2, scanner);

    /* initialize literal buffer to a reasonable but expansible size */
    yyext->literalalloc_ = 1024;
    yyext->literalbuffer_ = (char *) malloc(yyext->literalalloc_);
    yyext->literallen_ = 0;

    return scanner;
}

void
Lex::finish_scanner(Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr)
{
    if (yyextr->scanbuffer_len_ >= 8192)
        free(yyextr->scanbuffer_);
    if (yyextr->literalalloc_ >= 8192)
        free(yyextr->literalbuffer_);
    return ;
}

void Lex::lex_yyerror(const char *message, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr, YYLTYPE* lloc)
{
    const char *loc = yyextr->scanbuffer_ + *lloc;

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
Lex::lex_scanner_errposition(int location, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr, YYLTYPE* lloc)
{
	int			pos;

	if (location < 0)
		return 0;				/* no-op if location is unknown */

	return *(lloc);
}



LexHelper::LexHelper()
{
}
LexHelper::~LexHelper()
{
}
unsigned int 
LexHelper::hexval (unsigned char c) 
{
	if (c >= '0' && c <= '9')
		return c - '0';
	if (c >= 'a' && c <= 'f')
		return c - 'a' + 0xA;
	if (c >= 'A' && c <= 'F')
		return c - 'A' + 0xA;
	printf ("invalid hexadecimal digit\n");
	return 0;					/* not reached */
}
void
LexHelper::addlit(char *ytext, int yleng, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr)
{
    /* enlarge buffer if needed */
    if ((yyextr->literallen_ + yleng) >= yyextr->literalalloc_)
    {
        do
        {
            yyextr->literalalloc_ *= 2;
        } while ((yyextr->literallen_ + yleng) >= yyextr->literalalloc_);
        yyextr->literalbuffer_ = (char *) realloc(yyextr->literalbuffer_,
                                                yyextr->literalalloc_);
    }
    /* append new data */
    memcpy(yyextr->literalbuffer_ + yyextr->literallen_, ytext, yleng);
    yyextr->literallen_ += yleng;

	return; 
}
void 
LexHelper::addlitchar(unsigned char ychar, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr)
{
    /* enlarge buffer if needed */
    if ((yyextr->literallen_ + 1) >= yyextr->literalalloc_)
    {
        yyextr->literalalloc_ *= 2;
        yyextr->literalbuffer_ = (char *) realloc(yyextr->literalbuffer_,
                                                yyextr->literalalloc_);
    }
    /* append new data */
    yyextr->literalbuffer_[yyextr->literallen_] = ychar;
    yyextr->literallen_ += 1;

	return; 
}
char*
LexHelper::litbufdup(Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr)
{
    int         llen = yyextr->literallen_;

    char* new_addr = (char*) malloc(llen + 1);
    memcpy(new_addr, yyextr->literalbuffer_, llen);
    new_addr[llen] = '\0';
    return new_addr;
}

char *
LexHelper::litbuf_udeescape(unsigned char escape, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr, YYLTYPE* lloc)
{
    char       * new_addr;
    char       *litbuf,
               *in,
               *out;
    unsigned int    pair_first = 0;

    /* Make literalbuf null-terminated to simplify the scanning loop */
    litbuf = yyextr->literalbuffer_;
    litbuf[yyextr->literallen_] = '\0';

    /*
     * This relies on the subtle assumption that a UTF-8 expansion cannot be
     * longer than its escaped representation.
     */
    new_addr =(char*) malloc(yyextr->literallen_ + 1);

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
                    //ADVANCE_YYLLOC(in - litbuf + 3);    /* 3 for U&" */
					*(lloc) += (in - litbuf + 3) ;
                    Lex::lex_yyerror("invalid Unicode surrogate pair", yyscanner, yyextr, lloc);
                }
                *out++ = escape;
                in += 2;
            }
            else if (isxdigit((unsigned char) in[1]) &&
                     isxdigit((unsigned char) in[2]) &&
                     isxdigit((unsigned char) in[3]) &&
                     isxdigit((unsigned char) in[4]))
            {
                unsigned int    unicode;

                unicode = (hexval(in[1]) << 12) +
                    (hexval(in[2]) << 8) +
                    (hexval(in[3]) << 4) +
                    hexval(in[4]);
                LexHelper::check_unicode_value(unicode, in, yyscanner, yyextr);
                if (pair_first)
                {
                    if (LexHelper::is_utf16_surrogate_second(unicode,yyscanner, yyextr))
                    {
                        unicode = LexHelper::surrogate_pair_to_codepoint(pair_first, unicode,yyscanner,yyextr);
                        pair_first = 0;
                    }
                    else
                    {
                        //ADVANCE_YYLLOC(in - litbuf + 3);        /* 3 for U&" */
						*(lloc) += (in - litbuf + 3) ;
                        Lex::lex_yyerror("invalid Unicode surrogate pair", yyscanner, yyextr, lloc);
                    }
                }
                else if (LexHelper::is_utf16_surrogate_second(unicode,yyscanner, yyextr))
                    Lex::lex_yyerror("invalid Unicode surrogate pair", yyscanner, yyextr, lloc);

                if (LexHelper::is_utf16_surrogate_first(unicode,yyscanner, yyextr))
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
                unsigned int    unicode;

                unicode = (hexval(in[2]) << 20) +
                    (hexval(in[3]) << 16) +
                    (hexval(in[4]) << 12) +
                    (hexval(in[5]) << 8) +
                    (hexval(in[6]) << 4) +
                    hexval(in[7]);
                LexHelper::check_unicode_value(unicode, in, yyscanner, yyextr);
                if (pair_first)
                {
                    if (LexHelper::is_utf16_surrogate_second(unicode,yyscanner, yyextr))
                    {
                        unicode = LexHelper::surrogate_pair_to_codepoint(pair_first, unicode, yyscanner, yyextr);
                        pair_first = 0;
                    }
                    else
                    {
                        //ADVANCE_YYLLOC(in - litbuf + 3);        /* 3 for U&" */
						*(lloc) += (in - litbuf + 3) ;
                        Lex::lex_yyerror("invalid Unicode surrogate pair", yyscanner, yyextr, lloc);
                    }
                }
                else if (LexHelper::is_utf16_surrogate_second(unicode, yyscanner, yyextr))
                    Lex::lex_yyerror("invalid Unicode surrogate pair", yyscanner, yyextr, lloc);

                if (LexHelper::is_utf16_surrogate_first(unicode, yyscanner, yyextr))
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
                //ADVANCE_YYLLOC(in - litbuf + 3);        /* 3 for U&" */
				*(lloc) += (in - litbuf + 3) ;
                Lex::lex_yyerror("invalid Unicode escape value", yyscanner, yyextr, lloc);
            }
        }
        else
        {
            if (pair_first)
            {
                //ADVANCE_YYLLOC(in - litbuf + 3);        /* 3 for U&" */
				*(lloc) += (in - litbuf + 3) ;
                Lex::lex_yyerror("invalid Unicode surrogate pair", yyscanner, yyextr, lloc);
            }
            *out++ = *in++;
        }
    }

    /* unfinished surrogate pair? */
    if (pair_first)
    {
        //ADVANCE_YYLLOC(in - litbuf + 3);                /* 3 for U&" */
		*(lloc) += (in - litbuf + 3) ;
        Lex::lex_yyerror("invalid Unicode surrogate pair", yyscanner, yyextr, lloc);
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

unsigned char 
LexHelper::unescape_single_char(unsigned char c, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr)
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
                yyextr->saw_non_ascii_ = true;

            return c;
    }
	return c; 
}
int  
LexHelper::process_integer_literal(const char *token, Trans_YYSTYPE *lval, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr)
{
    long        val;
    char       *endptr;

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

bool 
LexHelper::is_utf16_surrogate_first(unsigned int c,Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr)
{
	return (c >= 0xD800 && c <= 0xDBFF);
}

bool 
LexHelper::is_utf16_surrogate_second(unsigned int c, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr)
{
	return (c >= 0xDC00 && c <= 0xDFFF);
}
 
unsigned int 
LexHelper::surrogate_pair_to_codepoint(unsigned int first, unsigned int second, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr)
{
	return ((first & 0x3FF) << 10) + 0x10000 + (second & 0x3FF);
}

void 
LexHelper::addunicode(unsigned int c,  Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr)
{
    char        buf[8];

    if (c == 0 || c > 0x10FFFF){
        //yyerror("invalid Unicode escape value");	
	}
    if (c > 0x7F)
    {
        //if (GetDatabaseEncoding() != PG_UTF8)
        //  yyerror("Unicode escape values cannot be used for code point values above 007F when the server encoding is not UTF8");
        yyextr->saw_non_ascii_ = true;
    }
    //unicode_to_utf8(c, (unsigned char *) buf);
    LexHelper::addlit(buf, strlen(buf), yyscanner, yyextr);

	return;
}

bool 
LexHelper::check_uescapechar(unsigned char escape, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr)
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
void 
LexHelper::check_escape_warning(Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr)
{
    if (yyextr->warn_on_first_escape_ && yyextr->escape_string_warning_)
        printf ("error.\n") ;
    yyextr->warn_on_first_escape_ = false;     /* warn only once per string */
	
	return; 
}

void 
LexHelper::check_string_escape_warning(unsigned char ychar, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr)
{
    if (ychar == '\'')
    {
        if (yyextr->warn_on_first_escape_ && yyextr->escape_string_warning_)
            printf ("error.\n");
        yyextr->warn_on_first_escape_ = false; /* warn only once per string */
    }
    else if (ychar == '\\')
    {
        if (yyextr->warn_on_first_escape_ && yyextr->escape_string_warning_)
            printf ("error.\n");
        yyextr->warn_on_first_escape_ = false; /* warn only once per string */
    }
    else
        LexHelper::check_escape_warning(yyscanner,yyextr);

	return;
}
void
LexHelper::check_unicode_value(unsigned int c, char *loc, Trans_yyscan_t yyscanner, Trans_yy_extra_type* yyextr) 
{
    //if (GetDatabaseEncoding() == PG_UTF8)
    //  return;

    if (c > 0x7F)
    {
        //ADVANCE_YYLLOC(loc - yyextra->literalbuf + 3);    /* 3 for U&" */
        //yyerror("Unicode escape values cannot be used for code point values above 007F when the server encoding is not UTF8");
    }
	return;
}

} //Lexical.
} //namespace Transformer.
