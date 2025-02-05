%{
#include <stdio.h>
#include <strings.h>
#include <stdlib.h>
#include "yacc_aux.h"
#include <stdbool.h>


int yylex(void);
int yyerror(const char *s);


family_tree* fam = NULL;

%}


%union{
    char* str_val;
    uint8_t u8_val;
    pred_type pred_val;
    triplet_aux triplet_val;
}


%token PREDICATE_INIT PREDICATE_GENDER
%token <str_val> PREDICATE_RELATION SUBJECT OBJECT
%type <triplet_val> Triplets
%type <pred_val> Predicate



%%
Lines : Lines Line
      | 
      ;

Line : Triplets '.' 

Triplets : SUBJECT Predicate OBJECT       { $$ = triplet_ctor( $1 , $2 , $3 );                  handle_predicate_action(fam, $$.subject, $$.predicate, $$.object); }
         | Triplets ',' OBJECT            { $$ = triplet_ctor( $1.subject , $1.predicate , $3); handle_predicate_action(fam, $$.subject, $$.predicate, $$.object); }
         | Triplets ';' Predicate OBJECT  { $$ = triplet_ctor( $1.subject , $3, $4);            handle_predicate_action(fam, $$.subject, $$.predicate, $$.object); }
         ;


Predicate : PREDICATE_INIT      { $$ = (pred_type) { .pred_type = PRED_INIT_IDX       , .string = NULL       }; }
          | PREDICATE_GENDER    { $$ = (pred_type) { .pred_type = PRED_GENDER_IDX     , .string = NULL       }; }
          | PREDICATE_RELATION  { $$ = (pred_type) { .pred_type = PRED_RELATION_IDX   , .string = strdup($1) }; }
          ;

%%

//#include "lex.yy.c"

int yyerror(const char *s)
{
    fprintf(stderr, "ERROR: %s \n", s);
    return 1;
}

int main(int argc, const char** argv)
{
    bool induced_relations = (argc == 2) && !strcmp(argv[1],"--induced-relations");

    fam = init_family_tree();

    yyparse();

    if(induced_relations)
        create_induced_relations(fam);

    print_dot_tree(fam);
    //free_family_tree(fam);
    return 0;
}
