%{
#include <stdio.h>
#include <strings.h>
#include <stdlib.h>

    //char yylex();
%}


#define NAMED_INDIVIDUAL 0x00
#define PERSON 0x01

%union{
    char* str;
    uint8_t val;
}

:<relation>

%token Subject PredicateInit PredicateGender PredicateRelation Object

%%
Line : Triplets '.'

Triplets : Subject Predicate Object       { /* Codigo de adicionar esta informação ao hashmap */ }
         | Triplets ',' Object            { /* Codigo de adicionar esta informação ao hashmap */ }
         | Triplets ';' Predicate Object  { /* Codigo de adicionar esta informação ao hashmap */ }
         ;


Predicate : PredicateInit      {  }
          | PredicateGender    {  }
          | PredicateRelation  {  }
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
