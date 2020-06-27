%{
/* Declaracoes C diversas */

#include "y.tab.h"
#include <ctype.h> 
#include <string.h>


%}

%option stack noyywrap

%x NEXT_PREDICATE NEXT_OBJECT END

%%

[ ]+|\n                                   { ; }
:[A-Za-z0-9_]+                            { yylval.str_val = strdup(yytext); BEGIN NEXT_PREDICATE; return SUBJECT; }

<NEXT_PREDICATE>[ ]+|\n                   { ; }
<NEXT_PREDICATE>"rdf:type"                { BEGIN NEXT_OBJECT; return PREDICATE_INIT; }
<NEXT_PREDICATE>":gender"                 { BEGIN NEXT_OBJECT; return PREDICATE_GENDER; }
<NEXT_PREDICATE>[A-Za-z0-9]*:[A-Za-z0-9]+ { yylval.str_val = strdup(yytext); BEGIN NEXT_OBJECT; return PREDICATE_RELATION; }

<NEXT_OBJECT>[ ]+|\n                      { ; }
<NEXT_OBJECT>[A-Za-z0-9]*:[A-Za-z0-9]+    { yylval.str_val = strdup(yytext); BEGIN END; return OBJECT; }

<END>[ ]+|\n                              { ; }
<END>"."                                  { BEGIN INITIAL;        return yytext[0]; }
<END>","                                  { BEGIN NEXT_OBJECT;    return yytext[0]; }
<END>";"                                  { BEGIN NEXT_PREDICATE; return yytext[0]; }

%%


int yywrap()
{ 
    return 1;
}