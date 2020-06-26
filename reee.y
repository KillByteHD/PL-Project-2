%{
#include <stdio.h>
#include <strings.h>
#include <stdlib.h>
#include "family.h"
#include "yacc_aux.h"

typedef struct __triplet_aux
{
    char* subject,
    pred_type pred;
    char* object;

} triplet_aux;


family_tree* fam = NULL;
%}

%union{
    char* str_val;
    uint8_t u8_val;
    pred_type pred_val;
    triplet_aux triplet_val;
}


%token SUBJECT PREDICATE_INIT PREDICATE_GENDER PREDICATE_RELATION OBJECT
%type <str_val> PredicateRelation
%type <triplet_val> Triplets
%type <pred_val> Predicate



%%
Line : Triplets '.'

Triplets : SUBJECT Predicate OBJECT       { handle_predicate_action(fam, $1, $2, $3); /* $$ = $2; */ }
         | Triplets ',' OBJECT            { /* $$ = $1; */ }
         | Triplets ';' Predicate OBJECT  { /* $$ = $3; */ }
         ;


Predicate : PREDICATE_INIT      { $$ = (pred_type) { .pred_type = PRED_INIT_IDX   , .string = NULL       }; }
          | PREDICATE_GENDER    { $$ = (pred_type) { .pred_type = PRED_GENDER_IDX , .string = NULL       }; }
          | PREDICATE_RELATION  { $$ = (pred_type) { .pred_type = PRED_INIT_IDX   , .string = strdup($1) }; }
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
    fam = init_family_tree();

    printf("Begin!\n");
    yyparse();
    printf("End!\n");

    print_dot_tree(fam);
    free_family_tree(fam);
    return 0;
}
