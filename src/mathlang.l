%{
#include <stdlib.h>
#include <string.h>
#include "mathlang.tab.h" 
#define YYDEBUG 1
int yywrap() { return 1; }
%}

letter  [a-zA-Z<>]
digit   [0-9]

%%

create       { return CREATE; }
set          { return SET; }
inc          { return INC; }
dec          { return DEC; }
add          { return ADD; }
sub          { return SUB; }
mul          { return MUL; }
div          { return DIV; }
cycle         { return CYCLE; }
endcycle         { return ENDCYCLE; }
if		{ return IF; }
endif		{ return ENDIF; }
show        { return SHOW; }
swap       { return SWAP; }
pow        { return POW; }
fact         { return FACT; }
fib	{ return FIB; }
g_progress	{ return G_PROGRESS; }
a_progress	{ return A_PROGRESS; }

"<"         { return '<'; }
">"         { return '>'; }

{letter}+    { strcpy(yylval.var, yytext); return VAR; }
{digit}+     { sscanf(yytext, "%d", &yylval.val); return VAL; }

[ \n] {}
. { write(2,yytext,1); return(yytext[0]); }

