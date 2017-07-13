/*
* path: parser/parserGramm.h
*/
#ifndef __PARSERGRAMM_H__
#define __PARSERGRAMM_H__

#include <types/nodes.h>
#include <parser/lex/scanner.h>
#include <../../query/parser/grammar.h>

//for the bision
#define TransYY_yyget_extra(yyscanner) (*((TransYY_yy_extra_type **) (yyscanner)))

typedef struct TransYY_yy_extra_type
{
    Trans_yy_extra_type         trans_yy_extra_;

    bool        have_lookahead_;         /* is lookahead info valid? */
    int         lookahead_token_;       /* one-token lookahead */
    Trans_YYSTYPE \
                lookahead_yylval_;      /* yylval for lookahead token */
    YYLTYPE     lookahead_yylloc_;      /* yylloc for lookahead token */
    char*       lookahead_end_;         /* end of current token */
    char        lookahead_hold_char_;   /* to be put back at *lookahead_end */

    Transformer::Types::ASTNode*    parsetree_;             //final parse tree.
} TransYY_yy_extra_type;

#endif  //__PARSERGRAMM_H__
