%{
#include <stdio.h>
#include <stdlib.h>
#include "scanType.h"
#include "parser.tab.h"

int line = 1;

char mapCharacter(char);
char* replaceChars(char*);

int setValue(int lineNum, int tokenClass, char *tokenStr) {
    yylval.tokenData = new TokenData;
    yylval.tokenData->lineNum = lineNum;
    yylval.tokenData->tokenClass = tokenClass;
    yylval.tokenData->tokenStr = strdup(tokenStr);
    if (tokenClass == NUMBER) {
        yylval.tokenData->nValue = atof(tokenStr);
    } else if (tokenClass == TRUE || tokenClass == FALSE) {
        yylval.tokenData->nValue = (tokenClass == TRUE) ? 1 : 0;
    } else if (tokenClass == CHAR || tokenClass == UNKNOWN) {
        yylval.tokenData->cValue = tokenStr[0];
    } else if (tokenClass == CHARCONST) {
	tokenStr++;
	tokenStr[strlen(tokenStr) - 1] = '\0';
        yylval.tokenData->cValue = (strlen(tokenStr) == 2) ? mapCharacter(tokenStr[1]) : tokenStr[0];
    } else if (tokenClass == STRCONST) {
	tokenStr++;
	tokenStr[strlen(tokenStr) - 1] = '\0';
	yylval.tokenData->tokenStr = tokenStr;
	yylval.tokenData->sValue = replaceChars(strdup(tokenStr));
    }
    yylval.tokenData->tokenStr = strdup(tokenStr);
    return tokenClass;
}

char mapCharacter(char ch) {
    char ans;
    switch (ch) {
	case '0': ans = '\0';
	    break;
//	case 't': ans = '\t';
//	    break;
	case 'n': ans = '\n';
	    break;
	case 'r': ans = '\r';
	    break;
	default: ans = ch;
	    break;
    }
    return ans;
}

char* replaceChars(char *str) {
    int inputIdx = 0;
    int outputIdx = 0;
    for (inputIdx = 0; inputIdx < strlen(str); inputIdx++)  {
	if (str[inputIdx] == '\\') {
	    str[outputIdx++] = mapCharacter(str[++inputIdx]);
	} else {
	    str[outputIdx++] = str[inputIdx];
	}
    }
    str[outputIdx] = '\0';
    return str;
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
"bool" { return setValue(line, BOOL, yytext); }
"and" { return setValue(line, AND, yytext); }
"or" { return setValue(line, OR, yytext); }
"then" { return setValue(line, THEN, yytext); }
"not" { return setValue(line, NOT, yytext); }
"while" { return setValue(line, WHILE, yytext); }
"do" { return setValue(line, DO, yytext); }
"static" { return setValue(line, STATIC, yytext); }
"break" { return setValue(line, BREAK, yytext); }
"char" { return setValue(line, CHAR, yytext); }
"loop" { return setValue(line, LOOP, yytext); }
"elsif" { return setValue(line, ELSIF, yytext); }
"forever" { return setValue(line, FOREVER, yytext); }
".." { return setValue(line, RANGE, yytext); }
\/\/.* ;
'[\\]?.' { return setValue(line, CHARCONST, yytext); }
(\")(.)*\" { return setValue(line, STRCONST, yytext); }
[a-zA-Z_][a-zA-Z_0-9]* { return setValue(line, ID, yytext); }
":" { return setValue(line, CLN, yytext); }
"!=" { return setValue(line, NE, yytext); }
"==" { return setValue(line, EQ, yytext); }
"=" { return setValue(line, ASSIGN, yytext); }
";" { return setValue(line, SC, yytext); }
"{" { return setValue(line, LCB, yytext); }
"}" { return setValue(line, RCB, yytext); }
"(" { return setValue(line, LP, yytext); }
")" { return setValue(line, RP, yytext); }
"[" { return setValue(line, LSB, yytext); }
"]" { return setValue(line, RSB, yytext); }
"<=" { return setValue(line, LE, yytext); }
">=" { return setValue(line, GE, yytext); }
"<" { return setValue(line, LT, yytext); }
">" { return setValue(line, GT, yytext); }
"--" { return setValue(line, MM, yytext); }
"++" { return setValue(line, PP, yytext); }
"+=" { return setValue(line, PE, yytext); }
"-=" { return setValue(line, ME, yytext); }
"*=" { return setValue(line, TE, yytext); }
"/=" { return setValue(line, DE, yytext); }
"/" { return setValue(line, D, yytext); }
"?" { return setValue(line, RAN, yytext); }
"," { return setValue(line, CMA, yytext); }
"%" { return setValue(line, MOD, yytext); }
"-" { return setValue(line, M, yytext); }
"*" { return setValue(line, T, yytext); }
"+" { return setValue(line, P, yytext); }
. { return setValue(line, UNKNOWN, yytext); }
%%
/*
"for" { return setValue(line, FOR, yytext); }
"in" { return setValue(line, IN, yytext); }
"[a-zA-Z][a-zA-Z0-9]*!" { return setValue(line, NOT, yytext); }
    (\")([^\\\"]|\\.)*\" { return setValue(line, STRCONST, yytext); }
    \".*\" { return setValue(line, STRCONST, yytext); }
. { printf("ERROR(%d): Invalid or misplaced input character: \".\"", line); }
"#" { printf("ERROR(%d): Invalid or misplaced input character: \"#\"", line);
*/
