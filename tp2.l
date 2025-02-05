%{
/* Declaracoes C diversas */

#include "yacc_aux.h"
#include "y.tab.h"
#include <ctype.h> 
#include <string.h>

int object_aux = 0;
%}

%option stack noyywrap

%x NEXT_PREDICATE NEXT_OBJECT NEXT_OBJECT_NAME END COMMENT

%%

^#                                        { BEGIN COMMENT; }
<COMMENT>.                                { ; }
<COMMENT>\n|\r                            { BEGIN INITIAL; }
[ ]+|\n                                   { ; }
:[A-Za-z0-9_]+                            { yylval.str_val = strdup(yytext+1); BEGIN NEXT_PREDICATE; return SUBJECT; }

<NEXT_PREDICATE>[ ]+|\n                   { ; }
<NEXT_PREDICATE>"rdf:type"                { BEGIN NEXT_OBJECT; return PREDICATE_INIT; }
<NEXT_PREDICATE>":gender"                 { BEGIN NEXT_OBJECT; return PREDICATE_GENDER; }
<NEXT_PREDICATE>:[A-Za-z0-9]+             { yylval.str_val = strdup(yytext+1); BEGIN NEXT_OBJECT_NAME; return PREDICATE_RELATION; }

<NEXT_OBJECT>[ ]+|\n                      { ; }
<NEXT_OBJECT>[A-Za-z0-9]*:[A-Za-z0-9]+    { object_aux = 0; yylval.str_val = strdup(yytext); BEGIN END; return OBJECT; }

<NEXT_OBJECT_NAME>[ ]+|\n                 { ; }
<NEXT_OBJECT_NAME>:[A-Za-z0-9_]+          { object_aux = 1; yylval.str_val = strdup(yytext+1); BEGIN END; return OBJECT; }

<END>[ ]+|\n                              { ; }
<END>"."                                  { BEGIN INITIAL;        return yytext[0]; }
<END>","                                  { if(object_aux) { BEGIN NEXT_OBJECT_NAME; } else { BEGIN NEXT_OBJECT; }    return yytext[0]; }
<END>";"                                  { BEGIN NEXT_PREDICATE; return yytext[0]; }

%%
