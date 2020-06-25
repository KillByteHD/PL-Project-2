%{
/* Declaracoes C diversas */

#include "y.tab.h"
#include <ctype.h> 
#include <string.h>


%}

%option stack noyywrap
%x SUBJECT COMMENT COMMA SEMICOLON

%%

^#               {BEGIN COMMENT;}

<COMMENT>(\n|\r) {BEGIN INITIAL;}

^:[A-Za-z0-9_]+/[ ]+                {yylval.str = strdup(yytext);return SUBJECT;}
[ ][A-Za-z0-9:]+/[ ]*[.]            {yylval.u8val = 0; return OBJECT}
[ ][A-Za-z0-9:]+/[ ]*[,]            {yylval.u8val = 0; return OBJECT; BEGIN COMMA;}
[ ][A-Za-z0-9:]+/[ ]*[;]            {yylval.u8val = 0; return OBJECT; BEGIN SEMICOLON;}
[ ][A-Za-z0-9:]+/[ ]+               {return PREDICATE_INIT;}

<COMMA>[A-Za-z0-9:]+/[ ]*[.]        {yylval.u8val = 1; yyval.str = strdup(yytext); return OBJECT; BEGIN INITIAL;}
<COMMA>[A-Za-z0-9:]+/[ ]*[,]        {yylval.u8val = 1; yyval.str = strdup(yytext); return OBJECT;}
<COMMA>[A-Za-z0-9:]+/[ ]*[;]        {yylval.u8val = 1; yval.str = strdup(yytext); return OBJECT; BEGIN SEMICOLON;}

<SEMICOLON>:"temSexo"/[ ]+[^.,;]    {return PREDICATE_GENDER;}
<SEMICOLON>[A-Za-z0-9:]+/[ ]+[^.,;] {yylval.str = strdup(yytext) ;return PREDICATE_RELATION;}
<SEMICOLON>[A-Za-z0-9:]+/[ ]*[.]    {yyval.str = strdup(yytext); return OBJECT; BEGIN INITIAL;}
<SEMICOLON>[A-Za-z0-9:]+/[ ]*[,]    {yyval.str = strdup(yytext); return OBJECT; BEGIN COMMA;}
<SEMICOLON>[A-Za-z0-9:]+/[ ]*[;]    {yyval.str = strdup(yytext); return OBJECT;}
 
%%

int yywrap(){ 
    return(1); 
}