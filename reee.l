%{
/* Declaracoes C diversas */
%}

%option stack noyywrap

%%
^a\n                { return CODE; }
.|\n                { return ERROR; }
%%