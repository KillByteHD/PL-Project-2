%{
#include <stdio.h>
#include <strings.h>
#include <stdlib.h>
#include "yacc_aux.h"


int yylex(void);
int yyerror(const char *s);


family_tree* fam = NULL;

%}


%union{
    char* string;
    uint8_t uint8;
}


%token <string> SUBJECT PREDICATE OBJECT
%type <triplet_val> Triplets



%%
Lines : Lines Line
      | 
      ;

Line : Triplets '.'

Triplets : SUBJECT PREDICATE OBJECT       { ; }
         | Triplets ',' OBJECT            { ; }
         | Triplets ';' PREDICATE OBJECT  { ; }
         ;

%%

//#include "lex.yy.c"

int yyerror(const char *s)
{
    fprintf(stderr, "ERROR: %s \n", s);
    return 1;
}

int main()
{
    fam = init_family_tree();

    //printf("Begin!\n");
    yyparse();
    //printf("End!\n");

    print_dot_tree(fam);
    //free_family_tree(fam);
    return 0;
}
