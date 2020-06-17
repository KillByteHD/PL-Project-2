%{
/* Declaracoes C diversas */
%}

%option stack noyywrap
%x SUBJECT PredicateAttrib OBJECT 
%x 
%%

<SUBJECT>URI

<PREDICATE>rdf:type    { return PredicateAttrib;   }
<PREDICATE>URI         { return PredicateRelation;   }

<OBJECT>URI

[ ]|\n                 { ; }

%%