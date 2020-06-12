%{
#include <stdio.h>
#include <strings.h>
#include <stdlib.h>

    //char yylex();
/* 
"Peixe":(123 - Pescada - 4 - < Unidade - 1 >) 
| "Cosmetica":(12345 - Sabao - 2 - < Unidade - 5 >) 
, (1221 - Espuma - 3 - < Volume - 1 >)
*/
%}


%token CODE ERROR
%%
Coisas : CODE { puts("YEET"); }
       | ERROR { puts("SAD YEET"); }
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
    printf("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\n");
    yyparse();
    printf("HEHEHEHEHEHEHEHEHEHEHEHEHEHEHEHEHEHEHEHEHEHEHEHEHEHE!\n");
    return(0);
}
