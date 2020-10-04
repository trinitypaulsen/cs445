%{
#include <stdio.h>
#include <stdlib.h>
#include "scanType.h"
#include "util.h"
#include "ourgetopt.h"
#include "globals.h"

extern int yylex();
extern int line;
extern FILE* yyin;
extern int ourGetopt(int, char**, char*);

#define YYERROR_VERBOSE
void yyerror(const char *msg) {
    printf("ERROR(%d): %s\n", line, msg);
}

TreeNode *addSibling(TreeNode *t, TreeNode *s) {
    TreeNode *tmp;
    if (t != NULL) {
	tmp = t;
	while (tmp->sibling != NULL) {
	    tmp = tmp->sibling;
	}
	tmp->sibling = s;
	return t;
    }
    return s;
}

void setType(TreeNode *t, ExpType type, bool isStatic) {
}

TreeNode *syntaxTree;

%}

%union {
    TokenData *tokenData;
    TreeNode *tree;
    ExpType type;
}

%type <tree> program declarationList declaration unmatched matched unmatchedIf matchedIf unmatchedFor
%type <tree> varDeclaration scopedVarDeclaration varDeclList varDeclInitialize varDeclId 
%type <tree> funDeclaration params paramList paramTypeList paramIdList paramId matchedFor
%type <tree> statement expressionStmt compoundStmt localDeclarations statementList 
%type <tree> returnStmt breakStmt call args argList constant unmatchedWhile matchedWhile
%type <tree> expression simpleExpression andExpression unaryRelExpression relExpression 
%type <tree> sumExpression mulExpression unaryExpression factor mutable immutable
%type <tokenData> typeSpecifier relop sumop mulop unaryop 

%token <tokenData> ID RETURN TRUE FALSE ELSE IF FOR WHILE IN BOOL CHAR INT BREAK STATIC 
%token <tokenData> NOT AND OR EQ NE LE LT GE GT ASSIGN PE ME TE DE MM PP T M RAN P D MOD 
%token <tokenData> LSB RSB LCB RCB LP RP SC CMA CLN STRCONST CHARCONST NUMCONST UNKNOWN 

%%
program			:	declarationList	 				    { syntaxTree=$1;}
			;

declarationList		:	declarationList declaration			    {addSibling($2, $1); $$=$1;}
			|	declaration					    {$$=$1;}
			;

declaration		:	varDeclaration					    {$$=$1;}
			|	funDeclaration					    {$$=$1;}
			;

varDeclaration		:	typeSpecifier varDeclList SC			    {$$=newDeclNode(VarK, Integer, $1->lineNum);}
			;
		
scopedVarDeclaration	:	STATIC typeSpecifier varDeclList SC		    {}
			|	typeSpecifier varDeclList SC			    {}
			;

varDeclList		:	varDeclList CMA varDeclInitialize		    {addSibling($3, $1); $$=$1;}
			|	varDeclInitialize				    {$$=$1;}
			;

varDeclInitialize	:	varDeclId					    {$$=$1;}
			|	varDeclId CLN simpleExpression			    {$$=$1; $$->child[0]=$3;}
			;
			
varDeclId		:	ID						    {
										     $$=newDeclNode(VarK, String, $1->lineNum);
										    }
			|	ID LSB NUMCONST RSB				    {
										     $$=newDeclNode(VarK, String, $1->lineNum);
										     $$->isArray = true;
										    }
			;

typeSpecifier		:	INT						    {$$=$1;}
			|	BOOL						    {$$=$1;}
			|	CHAR						    {$$=$1;}
			;

funDeclaration		:	typeSpecifier ID LP params RP statement		    {
										     $$=newDeclNode(FuncK, String, $2->lineNum);
										     $$->child[0] = $4;
                                                                                     $$->child[1] = $6;
										    }
			|	ID LP params RP statement			    {
										     $$=newDeclNode(FuncK, String, $1->lineNum);
										     $$->child[0] = $3;
                                                                                     $$->child[1] = $5;
										    }
			;

params			:	paramList					    {$$=$1;}
			|	/*empty*/					    {$$=NULL;}
			;
 
paramList		:	paramList SC paramTypeList			    {$$=$1; addSibling($3, $1);}
			|	paramTypeList					    {$$=$1;}
			;

paramTypeList		:	typeSpecifier paramIdList			    {}
			;

paramIdList		:	paramIdList CMA paramId				    {$$=$1; addSibling($3, $1);}
			|	paramId						    {$$=$1;}
			;

paramId			:	ID						    {$$=newExpNode(IdK, String, $1->lineNum); $$->attr.name = $1->sValue;}
			|	ID LSB RSB					    {
										     $$=newExpNode(IdK, String, $1->lineNum); 
										     $$->isArray=true; 
										     $$->attr.name = $1->sValue;
										    }
			;

expressionStmt		:	expression SC					    {$$=$1;}
			|	SC						    {$$=NULL;}
			;

compoundStmt		:	LCB localDeclarations statementList RCB		    {
										     $$ = newStmtNode(CompoundK, $1->lineNum);
                                                                                     $$->child[0] = $2;
                                                                                     $$->child[1] = $3;
										    }
			;

localDeclarations	:	localDeclarations scopedVarDeclaration		    {
										     if ($1 == NULL) {
                                                                                        $$=$2;
                                                                                     } else {
                                                                                        $$=$1;
                                                                                     }
										     addSibling($2, $1);
										    }
			|	/*empty*/					    {$$=NULL;}
			;

statement		:	matched						    {$$=$1;}
			|	unmatched					    {$$=$1;}
			;

matched			:	expressionStmt					    {$$=$1;}
                        |       compoundStmt					    {$$=$1;}
			|	returnStmt					    {$$=$1;}
			|	breakStmt					    {$$=$1;}
			|	matchedIf					    {$$=$1;}
			|	matchedFor					    {$$=$1;}
			|	matchedWhile					    {$$=$1;}
			;

unmatched		:	unmatchedIf					    {$$=$1;}
			|	unmatchedWhile					    {$$=$1;}
			|	unmatchedFor					    {$$=$1;}
			;

matchedIf		:	IF LP simpleExpression RP matched ELSE matched	    {
										     $$ = newStmtNode(IfK, $1->lineNum);
										     $$->child[0] = $3;
										     $$->child[1] = $5;
										     $$->child[2] = $7;
										    }
			;

unmatchedIf		:	IF LP simpleExpression RP statement		    {
										     $$ = newStmtNode(IfK, $1->lineNum);
										     $$->child[0] = $3;
										     $$->child[1] = $5;
										    }
			|	IF LP simpleExpression RP matched ELSE unmatched    {
										     $$ = newStmtNode(IfK, $1->lineNum);
                                                                                     $$->child[0] = $3;
                                                                                     $$->child[1] = $5;
                                                                                     $$->child[2] = $7;
										    }
			;

matchedFor		:	FOR LP ID IN ID RP matched			    {
										     $$ = newStmtNode(ForK, $1->lineNum);
										     $$->child[0]=newExpNode(IdK, String, $3->lineNum);
										     $$->attr.name = $3->sValue;
										     $$->child[1]=newExpNode(IdK, String, $5->lineNum);
										     $$->attr.name = $5->sValue;
                                                                                     $$->child[2] = $7;
										    }
			;

unmatchedFor		:	FOR LP ID IN ID RP unmatched			    {
										     $$ = newStmtNode(ForK, $1->lineNum);
										     $$->child[0]=newExpNode(IdK, String, $3->lineNum);
										     $$->attr.name = $3->sValue;
										     $$->child[1]=newExpNode(IdK, String, $5->lineNum);
										     $$->attr.name = $5->sValue;
                                                                                     $$->child[2] = $7;
										    }
			;

matchedWhile		:	WHILE LP simpleExpression RP matched		    {
										     $$ = newStmtNode(WhileK, $1->lineNum);
                                                                                     $$->child[0] = $3;
                                                                                     $$->child[1] = $5;
										    }
			;

unmatchedWhile		:	WHILE LP simpleExpression RP unmatched		    {
										     $$ = newStmtNode(WhileK, $1->lineNum);
                                                                                     $$->child[0] = $3;
                                                                                     $$->child[1] = $5;
										    }
			;

statementList		:	statementList statement				    {
										     if ($1 == NULL) {
											$$=$2;
										     } else {
											$$=$1; 
											addSibling($2, $1);
										     }
										    }
			|	/*empty*/					    {$$=NULL;}
			;
		
returnStmt		:	RETURN SC					    {$$ = newStmtNode(ReturnK, $1->lineNum);}
			|	RETURN expression SC				    {$$ = newStmtNode(ReturnK, $1->lineNum); $$->child[0]=$2;}
			;

breakStmt		:	BREAK SC					    {$$ = newStmtNode(BreakK, $1->lineNum);}
			;

expression		:	mutable ASSIGN expression			    {
										     $$=newExpNode(AssignK, String, $2->lineNum);
										     $$->child[0]=$1;
                                                                                     $$->child[1]=$3;
										    }
			|	mutable PE expression				    {
										     $$=newExpNode(AssignK, String, $2->lineNum);
										     $$->child[0]=$1;
                                                                                     $$->child[1]=$3;
										    }
			|	mutable ME expression				    {
										     $$=newExpNode(AssignK, String, $2->lineNum);
										     $$->child[0]=$1;
                                                                                     $$->child[1]=$3;
										    }
			|	mutable TE expression				    {
										     $$=newExpNode(AssignK, String, $2->lineNum);
										     $$->child[0]=$1;
                                                                                     $$->child[1]=$3;
										    }
			|	mutable DE expression				    {
										     $$=newExpNode(AssignK, String, $2->lineNum);
										     $$->child[0]=$1;
                                                                                     $$->child[1]=$3;
										    }
			|	mutable PP					    {
										     $$=newExpNode(AssignK, String, $2->lineNum);
										     $$->child[0]=$1;
										    }
			|	mutable MM					    {
										     $$=newExpNode(AssignK, String, $2->lineNum);
										     $$->child[0]=$1;
										    }
			|	simpleExpression				    {$$=$1;}
			;

simpleExpression	:	simpleExpression OR andExpression		    {
										     $$=newExpNode(OpK, Char, $2->lineNum);
										     //FIXME set or
                                                                                     $$->child[0]=$1;
                                                                                     $$->child[1]=$3;
										    }
			|	andExpression					    {$$=$1;}
			;

andExpression		:	andExpression AND unaryRelExpression		    {
										     $$=newExpNode(OpK, Char, $2->lineNum);
                                                                                     $$->child[0]=$1;
                                                                                     $$->child[1]=$3;
										    }
			|	unaryRelExpression				    {$$=$1;}
			;

unaryRelExpression	:	NOT unaryRelExpression				    {
										     $$=newExpNode(OpK, Char, $1->lineNum);
										     $$->child[0]=$2;
										    }
			|	relExpression					    {$$=$1;}
			;

relExpression		:	sumExpression relop sumExpression		    {
										     $$=newExpNode(OpK, Char, $2->lineNum);
										     $$->child[0]=$1;
                                                                                     $$->child[1]=$3;
										    }
			|	sumExpression					    {$$=$1;}
			;

relop			:	LE						    {$$=$1;}
			|	LT                                                  {$$=$1;}
			|	GT                                                  {$$=$1;}
			|	GE                                                  {$$=$1;}
			|	EQ                                                  {$$=$1;}
			|	NE						    {$$=$1;}
			;

sumExpression		:       sumExpression sumop mulExpression		    {
										     $$=newExpNode(OpK, Char, $2->lineNum);
										     $$->child[0]=$1;
										     $$->child[1]=$3;
										    } 
			|	mulExpression					    {$$=$1;}
			;

sumop			:	P						    {$$=$1;}
			|	M						    {$$=$1;}
			;

mulExpression		:	mulExpression mulop unaryExpression		    {
										     $$=newExpNode(OpK, Char, $2->lineNum);
										     $$->child[0]=$1;
										     $$->child[1]=$3;
										    }
			|	unaryExpression					    {$$=$1;}
			;

mulop			:	T						    {$$=$1;}
			|	D						    {$$=$1;}
			|	MOD						    {$$=$1;}
			;

unaryExpression		:	unaryop unaryExpression				    {
										     $$=newExpNode(OpK, Char, $1->lineNum);
										     $$->child[0]=$2;
										    }
			|	factor						    {$$=$1;}
			;

unaryop			:	M						    {$$=$1;}
			|	T						    {$$=$1;}
			|	RAN						    {$$=$1;}
			;

factor			:	immutable					    {$$=$1;}
			|	mutable						    {$$=$1;}
			;

mutable			:	ID						    {
										     $$=newExpNode(IdK, String, $1->lineNum);
										     $$->attr.name=$1->sValue;
										    }
			|	mutable LSB expression RSB			    {$$->child[0] = $3;}
			;

immutable		:	LP expression RP				    {$$=$2;}
			|	call						    {$$=$1;}
			|	constant					    {$$=$1;}
			;

call			:	ID LP args RP					    {
										     $$ = newExpNode(CallK, String, $1->lineNum);
										     $$->attr.name = $1->sValue;
										     $$->child[0] = $3;
										    }
			;

args			:	argList						    {$$=$1;}
			|	/*empty*/					    {$$=NULL;}
			;

argList			:	argList CMA expression				    {$$=$1; addSibling($3, $1);}
			|	expression					    {$$=$1;}
			;

constant		:	NUMCONST					    {
										     $$ = newExpNode(ConstantK, Integer, $1->lineNum);
										     $$->attr.value = $1->nValue;
										     $$->expType = Integer;
										    }
			|	CHARCONST					    {
										     $$ = newExpNode(ConstantK, Char, $1->lineNum);
										     $$->attr.cvalue = $1->cValue;
										     $$->expType = Char;
										    }
			|	STRCONST					    {
										     $$ = newExpNode(ConstantK, Char, $1->lineNum);
										     $$->attr.string = $1->sValue;
										     $$->expType = Char;
										     $$->isArray = true;
										    }
			|	TRUE						    {
										     $$ = newExpNode(ConstantK, Boolean, $1->lineNum);
										     $$->expType = Boolean;
										     $$->attr.value = $1->nValue;
										    }
			|	FALSE						    {
										     $$ = newExpNode(ConstantK, Boolean, $1->lineNum);
										     $$->expType = Boolean;
                                                                                     $$->attr.value = $1->nValue;
										    }
			;
%%

int main(int argc, char **argv) {
    int pflag, errflag;
    char c;
    pflag = errflag = 0;
    TreeNode *t;
    while ((c = ourGetopt(argc, argv, (char*) "dp")) != EOF) {
	switch (c) {
	    case 'd':
		yydebug = 1;
		break;
	    case 'p':
		pflag = 1;
		break;
	    default:
		errflag = 1;
		printf("invalid flag\n");
		exit(2);
		break;
	}
    }
    if (argc >= 2) {
	FILE *myfile = fopen(argv[argc - 1], "r");
	if (!myfile) {
	    printf("Invalid file %s\n", argv[argc - 1]);
	    return -1;
	}
	yyin = myfile;
    }
    yyparse();
    if (pflag) {
	printTree2(syntaxTree);
/*	int i, j;
	for (i = 0; i < 3; i++) {
	    if (t->child[i] != NULL) {
		printf("Child: %d ", i);
		printTree(syntaxTree);
	    }
	}
	if (t->sibling != NULL) {
	    printf("Sibling: ");
	    printTree(syntaxTree);
	}*/
    }
    return 0;
}
