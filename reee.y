%{
#include <stdio.h>
#include <strings.h>
#include <stdlib.h>

    //char yylex();
%}


%union{
    char* str;
}

%token Subject PredicateAttrib PredicateRelation Object
%%

Line : Triplets '.'

Triplets : Subject Predicate Object      { /* Codigo de adicionar esta informação ao hashmap */ }
         | Triplets ',' Object            { /* Codigo de adicionar esta informação ao hashmap */ }
         | Triplets ';' Predicate Object  { /* Codigo de adicionar esta informação ao hashmap */ }
         ;

Predicate : PredicateAttrib
          | PredicateRelation
          ;

%%

#include "lex.yy.c"

int yyerror(char *s)
{
    fprintf(stderr, "ERRO: %s \n", s);
    return 1;
}

int main()
{
    printf("Begin!\n");
    yyparse();
    printf("End!\n");
    return(0);
}
