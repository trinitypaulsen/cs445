%{
#include <stdio.h>
#include <stdlib.h>
#include "scanType.h"
#include "parser.tab.h"

int line = 1;

int setValue(int lineNum, int tokenClass, char *sValue) {
    yylval.tokenData = new TokenData;
    yylval.tokenData->lineNum = lineNum;
    yylval.tokenData->tokenClass = tokenClass;
    if (tokenClass == NUMBER || tokenClass == TRUE || tokenClass == FALSE) {
        yylval.tokenData->nValue = atof(sValue);
    } else if (tokenClass == CHAR || tokenClass == UNKNOWN) {
        yylval.tokenData->cValue = sValue[0];
    } else if (tokenClass == STRCONST) {
	sValue++;
	sValue[strlen(sValue) - 1] = '\0';
	yylval.tokenData->sValue = strdup(sValue);
    }
    yylval.tokenData->tokenStr = strdup(sValue);
    return tokenClass;
}
%}

%option noyywrap

%%
\n { line++; }
[ \t] ;
[0-9]+   { return setValue(line, NUMBER, yytext); }
"int" { return setValue(line, INT, yytext); }
"return" { return setValue(line, RETURN, yytext); }
"true" { return setValue(line, TRUE, yytext); }
"false" { return setValue(line, FALSE, yytext); }
"if" { return setValue(line, IF, yytext); }
"else" { return setValue(line, ELSE, yytext); }
(\")([^\\\"]|\\.)*\" { return setValue(line, STRCONST, yytext); }
[a-zA-Z_][a-zA-Z_0-9]* { return setValue(line, ID, yytext); }
"==" { return setValue(line, EQ, yytext); }
"=" { return setValue(line, ASSIGN, yytext); }
";" { return setValue(line, SC, yytext); }
"{" { return setValue(line, LCB, yytext); }
"}" { return setValue(line, RCB, yytext); }
"(" { return setValue(line, LP, yytext); }
")" { return setValue(line, RP, yytext); }
"[" { return setValue(line, LSB, yytext); }
"]" { return setValue(line, RSB, yytext); }
"<" { return setValue(line, LT, yytext); }
">" { return setValue(line, GT, yytext); }
"/" { return setValue(line, D, yytext); }
"?" { return setValue(line, RAN, yytext); }
"-" { return setValue(line, M, yytext); }
. { return setValue(line, UNKNOWN, yytext); }
%%
/*
"for" { return setValue(line, FOR, yytext); }
"while" { return setValue(line, WHILE, yytext); }
"in" { return setValue(line, IN, yytext); }
"bool" { return setValue(line, BOOL, yytext); }
"char" { return setValue(line, CHAR, yytext); }
"break" { return setValue(line, BREAK, yytext); }
"static" { return setValue(line, STATIC, yytext); }
"[a-zA-Z][a-zA-Z0-9]*!" { return setValue(line, NOT, yytext); }
"&" { return setValue(line, AND, yytext); }
"|" { return setValue(line, OR, yytext); }
"!=" { return setValue(line, NE, yytext); }
"<=" { return setValue(line, LE, yytext); }
">=" { return setValue(line, GE, yytext); }
"+=" { return setValue(line, PE, yytext); }
"-=" { return setValue(line, ME, yytext); }
"*=" { return setValue(line, TE, yytext); }
"/=" { return setValue(line, DE, yytext); }
"--" { return setValue(line, MM, yytext); }
"++" { return setValue(line, PP, yytext); }
"*" { return setValue(line, T, yytext); }
"+" { return setValue(line, P, yytext); }
"%" { return setValue(line, MOD, yytext); }
"," { return setValue(line, CMA, yytext); }
":" { return setValue(line, CLN, yytext); }
    \".*\" { return setValue(line, STRCONST, yytext); }
. { printf("ERROR(%d): Invalid or misplaced input character: \".\"", line); }
"#" { printf("ERROR(%d): Invalid or misplaced input character: \"#\"", line);
*/
