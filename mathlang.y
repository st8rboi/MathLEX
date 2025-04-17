%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
char buf[2048];

int yylex();
void yyerror(const char *s);

%}

%union {
    int val;
    char var[2048];
    char *str;
}

%token <val> VAL
%token <var> VAR
%token CREATE SET INC DEC ADD SUB MUL DIV CYCLE ENDCYCLE IF ENDIF SHOW SWAP POW FACT FIB G_PROGRESS A_PROGRESS
%type <str> str oper prog

%define parse.error verbose
%debug

%%

prog: str {
    $$ = malloc(2048);
    sprintf($$, "#include <stdio.h>\n\nint main() {%s \ngetchar();\nreturn 0;\n}", $1);
    printf("%s\n", $$);
}

str: oper {
    sprintf($$, "%s", $1);
}
| oper str {
    sprintf($$, "%s\n%s", $1, $2);
};

oper: CREATE VAR {
    $$ = malloc(2048);  
    sprintf($$, "int %s;", $<var>2);
}
| CREATE VAR VAL {
    $$ = malloc(2048);  
    sprintf($$, "int %s=%d;", $<var>2, $<val>3);
}
| SET VAR VAL {
    $$ = malloc(2048);  
    sprintf($$, "%s=%d;", $<var>2, $<val>3); 
}
| SET VAR VAR {
    $$ = malloc(2048);  
    sprintf($$, "%s=%s;", $<var>2, $<var>3); 
}
| INC VAR {
    $$ = malloc(2048);  
    sprintf($$, "%s+=1;", $<var>2); 
}
| DEC VAR {
    $$ = malloc(2048);  
    sprintf($$, "%s-=1;", $<var>2); 
}
| ADD VAR VAL {
    $$ = malloc(2048);  
    sprintf($$, "%s+=%d;", $<var>2, $<val>3); 
}
| ADD VAR VAR {
    $$ = malloc(2048);  
    sprintf($$, "%s+=%s;", $<var>2, $<var>3); 
}
| SUB VAR VAL {
    $$ = malloc(2048);  
    sprintf($$, "%s-=%d;", $<var>2, $<val>3); 
}
| SUB VAR VAR {
    $$ = malloc(2048);  
    sprintf($$, "%s-=%s;", $<var>2, $<var>3); 
}
| MUL VAR VAL {
    $$ = malloc(2048);  
    sprintf($$, "%s*=%d;", $<var>2, $<val>3); 
}
| MUL VAR VAR {
    $$ = malloc(2048);  
    sprintf($$, "%s*=%s;", $<var>2, $<var>3); 
}
| DIV VAR VAL {
    $$ = malloc(2048);  
    sprintf($$, "%s/=%d;", $<var>2, $<val>3); 
}
| DIV VAR VAR {
    $$ = malloc(2048);  
    sprintf($$, "%s/=%s;", $<var>2, $<var>3); 
}
| SHOW VAR {
    $$ = malloc(2048);  
    sprintf($$, "printf(\"%%d\\n\", %s);", $<var>2);
}
| CYCLE VAR '>' VAL str ENDCYCLE {
    $$ = malloc(2048);  
    sprintf($$, "while(%s > %d) {%s}", $<var>2, $<val>4, $<var>5);
}
| CYCLE VAR '<' VAL str ENDCYCLE {
    $$ = malloc(2048);  
    sprintf($$, "while(%s < %d) {%s}", $<var>2, $<val>4, $<var>5);
}
| CYCLE VAR '>' VAR str ENDCYCLE {
    $$ = malloc(2048);  
    sprintf($$, "while(%s > %s) {%s}", $<var>2, $<var>4, $<var>5);
}
| CYCLE VAR '<' VAR str ENDCYCLE {
    $$ = malloc(2048);  
    sprintf($$, "while(%s < %s) {%s}", $<var>2, $<var>4, $<var>5);
}
| IF VAR '>' VAL str ENDIF {
    $$ = malloc(2048);  
    sprintf($$, "if(%s > %d) {%s}", $<var>2, $<val>4, $<var>5);
}
| IF VAR '<' VAL str ENDIF {
    $$ = malloc(2048);  
    sprintf($$, "if(%s < %d) {%s}", $<var>2, $<val>4, $<var>5);
}
| IF VAR '>' VAR str ENDIF {
    $$ = malloc(2048);  
    sprintf($$, "if(%s > %s) {%s}", $<var>2, $<var>4, $<var>5);
}
| IF VAR '<' VAR str ENDIF {
    $$ = malloc(2048);  
    sprintf($$, "if(%s < %s) {%s}", $<var>2, $<var>4, $<var>5);
}
| SWAP VAR VAR { 
    $$ = malloc(2048);  
    sprintf($$, "int temp = %s; %s = %s; %s = temp;", $<var>2, $<var>2, $<var>3, $<var>3); 
}
| POW VAR VAL VAL { 
    $$ = malloc(2048);  
    sprintf($$, "(int)%s = pow(%d, %d);", $<var>2, $<val>3, $<val>4); 
}
| FACT VAR VAR {
    $$ = malloc(2048); 
    sprintf($$, "{ %s = 1; for(int i = 1; i <= %s; i++) %s *= i; }", $<var>2, $<var>3, $<var>2);
}
| FACT VAR VAL {
    $$ = malloc(2048); 
    sprintf($$, "{ %s = 1; for(int i = 1; i <= %d; i++) %s *= i; }", $<var>2, $<val>3, $<var>2);
}
| FIB VAR VAR {
    $$ = malloc(2048); 
    sprintf($$, "{ int a = 0, b = 1, temp; for(int i = 2; i <= %s; i++) { temp = a + b; a = b; b = temp; } %s = (%s > 1 ? b : %s); }", $<var>3, $<var>2, $<var>3, $<var>3);
}
| FIB VAR VAL {
    $$ = malloc(2048); 
    sprintf($$, "{ int a = 0, b = 1, temp; for(int i = 2; i <= %d; i++) { temp = a + b; a = b; b = temp; } %s = (%d > 1 ? b : %d); }", $<val>3, $<var>2, $<val>3, $<val>3); 
}
| G_PROGRESS VAR VAL VAL VAL { 
    $$ = malloc(2048);  
    sprintf($$, "{ %s = %d * (int)pow(%d, %d - 1); }", $<var>2, $<val>3, $<val>4, $<val>5); 
}
| A_PROGRESS VAR VAL VAL VAL { 
    $$ = malloc(2048);  
    sprintf($$, "{ %s = %d + (%d) * (%d - 1); }", $<var>2, $<val>3, $<val>4, $<val>5); 
}
;


%%

void yyerror(const char *s) {
    printf("err: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}

