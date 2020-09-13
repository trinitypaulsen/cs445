%{
#include <stdio.h>
#include "scanType.h"

extern int yylex();
extern int line;

#define YYERROR_VERBOSE
void yyerror(const char *msg) {
    printf("ERROR(%d): %s", line, msg);
}
%}

%union {
    TokenData *tokenData;
}

%token <tokenData> ID NUMBER 
%token <tokenData> RETURN TRUE FALSE
%token <tokenData> ELSE IF FOR WHILE IN
%token <tokenData> BOOL CHAR INT
%token <tokenData> BREAK STATIC
%token <tokenData> NOT AND OR EQ NE LE LT GE GT
%token <tokenData> ASSIGN PE ME TE DE MM PP
%token <tokenData> T M RAN P D MOD
%token <tokenData> LSB RSB LCB RCB LP RP SC CMA CLN
%token <tokenData> UNKNOWN
%token <tokenData> STRCONST

%%
tokenList   :   tokenList token
            |   token
            ;

token   :   ID  { printf("Line %d Token: ID Value: %s\n", $1->lineNum, $1->tokenStr); }
        |   NUMBER  { printf("Line %d Token: NUMCONST Value: %d  Input: %s\n", $1->lineNum, $1->nValue, $1->tokenStr); }
        |   RETURN  { printf("Line %d Token: RETURN\n", $1->lineNum); }
        |   TRUE  { printf("Line %d Token: BOOLCONST Value: %d  Input: %s\n", $1->lineNum, $1->nValue, $1->tokenStr); }
        |   FALSE  { printf("Line %d Token: BOOLCONST Value: %d  Input: %s\n", $1->lineNum, $1->nValue, $1->tokenStr); }
        |   ELSE  { printf("Line %d Token: ELSE\n", $1->lineNum); }
        |   IF  { printf("Line %d Token: IF\n", $1->lineNum); }
        |   FOR  { printf("Line %d Token: FOR\n", $1->lineNum); }
        |   WHILE  { printf("Line %d Token: WHILE\n", $1->lineNum); }
        |   IN  { printf("Line %d Token: IN\n", $1->lineNum); }
        |   BOOL  { printf("Line %d Token: BOOL\n", $1->lineNum); }
        |   CHAR  { printf("Line %d Token: CHAR\n", $1->lineNum); }
        |   INT  { printf("Line %d Token: INT\n", $1->lineNum); }
        |   BREAK  { printf("Line %d Token: BREAK\n", $1->lineNum); }
        |   STATIC  { printf("Line %d Token: STATIC\n", $1->lineNum); }
        |   NOT  { printf("Line %d Token: NOTEQ\n", $1->lineNum); }
        |   AND  { printf("Line %d Token: AND\n", $1->lineNum); }
        |   OR  { printf("Line %d Token: OR\n", $1->lineNum); }
        |   EQ  { printf("Line %d Token: EQ\n", $1->lineNum); }
        |   NE  { printf("Line %d Token: NOTEQ\n", $1->lineNum); }
        |   LE  { printf("Line %d Token: LESSEQ\n", $1->lineNum); }
        |   LT  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   GE  { printf("Line %d Token: GRTEQ\n", $1->lineNum); }
        |   GT  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   ASSIGN  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   PE  { printf("Line %d Token: ADDASS\n", $1->lineNum); }
        |   ME  { printf("Line %d Token: SUBASS\n", $1->lineNum); }
        |   TE  { printf("Line %d Token: MULASS\n", $1->lineNum); }
        |   DE  { printf("Line %d Token: DIVASS\n", $1->lineNum); }
        |   MM  { printf("Line %d Token: DEC\n", $1->lineNum); }
        |   PP  { printf("Line %d Token: INC\n", $1->lineNum); }
        |   T  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   M  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   RAN  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   P  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   D  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   MOD  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   LSB  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   RSB  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   LCB  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   RCB  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   LP  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   RP  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   SC  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   CMA  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   CLN  { printf("Line %d Token: %s\n", $1->lineNum, $1->tokenStr); }
        |   STRCONST  { printf("Line %d Token: STRINGCONST Value: '%s'  Input: \"%s\"\n", $1->lineNum, $1->sValue, $1->tokenStr); }
        |   UNKNOWN  { printf("ERROR(%d): Invalid or misplaced input character: \"%c\"\n", $1->lineNum, $1->cValue); }
        ;
%%

int main() {
    yyparse();
    return 0;
}