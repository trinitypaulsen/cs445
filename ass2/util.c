#include "scanType.h"
#include "globals.h"
#include "util.h"

#define INDENT indentno+=1
#define UNINDENT indentno-=1

static int indentno = 0;

static void printSpaces(void) {
    int i;
    for (i = 0; i < indentno; i++) {
	printf(".   ");
    }
}

void printTree2(TreeNode *tree) {
    printNode(tree, 0);
    printf("Hello world");
}

char * indent(int depth) {
    int i;
    char* result = (char*) malloc(4*depth+1);
    for (i = 0; i < depth; i++) {
	strncpy((char*) (result + 4 * i), ".   ", 4);
    }
    result[depth * 4] = '\0';
    return result;
}

void printNode(TreeNode *node, int depth) {
    int i;
    //print this node
    printf("%s%d, %d\n", indent(depth), node->attr.value, node->lineno);
    //print the children
   printf("%ld", (long) node->child[0]); 
/*    for (i = 0; i < MAXCHILDREN && node->child[i] != NULL; i++) {
	printf("%ld", (long) node->child[i]);
	printNode(node->child[i], depth + 1);
    }*/
}

void printTree(TreeNode *tree) {
    printf("Root line num: %d\n", tree->lineno);
    printf("Child 0: %ld\n", (long) tree->child[0]);
    printf("Sibling 0: %ld\n", (long) tree->sibling);
/*    int i;
    INDENT;
    while (tree != NULL) {
	printSpaces();
	if (tree->nodekind == StmtK) {
	    switch (tree->kind.stmt) {
		case NullK:
		    printf("Null [line: %d]\n", tree->lineno);
		    break;
		case IfK:
		    printf("If [line: %d]\n", tree->lineno);
		    break;
		case WhileK:
		    printf("While [line: %d]\n", tree->lineno);
		    break;
		case CompoundK:
		    printf("Compound [line: %d]\n", tree->lineno);
		    break;
		case ReturnK:
		    printf("Return [line: %d]\n", tree->lineno);
		    break;
		case ForK:
		    printf("For [line: %d]\n", tree->lineno);
		    break;
		case BreakK:
		    printf("Break [line: %d]\n", tree->lineno);
		    break;
		default:
		    printf("Unknown kind\n");
		    break;
	    }
	}
	if (tree->nodekind == ExpK) {
	    switch (tree->kind.exp) {
		case OpK:
		    printf("Op: ");
		    //printOp(tree->attr.op);
		    printf(" [line: %d]\n", tree->lineno);
		    break;
		case ConstantK:
		    printf("Const: %d [line: %d]\n", tree->attr.value, tree->lineno);
		    break;
		case IdK:
		    printf("Id: %s [line: %d]\n", tree->attr.name, tree->lineno);
		    break;
		case AssignK:
		    printf("Assign: ");
		    //printOp(tree->attr.op);
		    printf("[line: %d]\n", tree->lineno);
		    break;
		case InitK:
		    printf("???? [line: %d]\n", tree->lineno); //FIXME
		    break;
		case CallK:
		    printf("Call: %s [line: %d]\n", tree->attr.string, tree->lineno);
		    break;
		default:
		    printf("Unknown kind\n");
		    break;
	    }
	}
	if (tree->nodekind == DeclK) {
	    switch (tree->kind.decl) {
		case VarK:
		    if (tree->isArray) {
			printf("Var %s is array of type %d [line: %d]\n", 
			tree->attr.string, tree->expType, tree->lineno);
		    } else {
			printf("Var %s of type %d [line: %d]\n", 
			tree->attr.string, tree->expType, tree->lineno);
		    }
		    break;
		case FuncK:
		    printf("Func main returns type void [line: %d]\n", tree->lineno);
		    break;
		case ParamK:
		    if (tree->isArray) {
			printf("Param %s is array of type %d [line: %d]\n", 
			tree->attr.string, tree->expType, tree->lineno);
		    } else {
			printf("Param %s of type %d [line: %d]\n", 
			tree->attr.string, tree->expType, tree->lineno);
		    }
		    break;
		default:
		    printf("Unknown kind\n");
		    break;
	    }
	}
    }*/
}

TreeNode* newStmtNode(StmtKind kind, int lineNum) {
    TreeNode *t = (TreeNode*) malloc(sizeof(TreeNode));
    int i;
    for (i = 0; i < MAXCHILDREN; i++) {
	t->child[i] = NULL;
    }
    t->sibling = NULL;
    t->nodekind = StmtK;
    t->kind.stmt = kind;
    t->lineno = lineNum;
    return t;
}

TreeNode* newExpNode(ExpKind kind, ExpType type, int lineNum) {
    TreeNode *t = (TreeNode*) malloc(sizeof(TreeNode));
    int i;
    for (i = 0; i < MAXCHILDREN; i++) {
	t->child[i] = NULL;
    }
    t->sibling = NULL;
    t->nodekind = ExpK;
    t->kind.exp = kind;
    t->lineno = lineNum;
    t->expType = type;
    return t;
}

TreeNode* newDeclNode(DeclKind kind, ExpType type, int lineNum) {
    TreeNode *t = (TreeNode*) malloc(sizeof(TreeNode));
    int i;
    for (i = 0; i < MAXCHILDREN; i++) {
	t->child[i] = NULL;
    }
    t->sibling = NULL;
    t->nodekind = DeclK;
    t->kind.decl = kind;
    t->lineno = lineNum;
    t->expType = type;
    return t;
}
