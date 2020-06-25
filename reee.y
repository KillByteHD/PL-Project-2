%{
#include <stdio.h>
#include <strings.h>
#include <stdlib.h>
#include "family.h"
#include "yacc_aux.h"
%}




%union{
    char* str;
    uint8_t u8val;
}


%token Subject PREDICATE_INIT PREDICATE_GENDER PREDICATE_RELATION Object
%type <u8val> Triplets Predicate


%%
Line : Triplets '.'

Triplets : Subject Predicate Object       { $$ = $2; }
         | Triplets ',' Object            { $$ = $1; }
         | Triplets ';' Predicate Object  { $$ = $3; }
         ;


Predicate : PredicateInit      { $$ = PRED_INIT_IDX     /* $1 */ }
          | PredicateGender    { $$ = PRED_GENDER_IDX   /* $1 */ }
          | PredicateRelation  { $$ = PRED_RELATION_IDX /* $1 */ }
          ;
%%

#include "lex.yy.c"

int yyerror(char *s)
{
    fprintf(stderr, "ERROR: %s \n", s);
    return 1;
}

int main()
{
    printf("Begin!\n");
    yyparse();
    printf("End!\n");
    return 0;
}
