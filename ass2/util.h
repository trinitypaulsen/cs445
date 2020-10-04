#ifndef _UTIL_H_
#define _UTIL_H_
#include "scanType.h"
#include "globals.h"

TreeNode* newStmtNode(StmtKind kind, int lineNum);

TreeNode* newExpNode(ExpKind kind, ExpType type, int lineNum);

TreeNode* newDeclNode(DeclKind kind, ExpType type, int lineNum);

void printTree(TreeNode*);
void printNode(TreeNode*, int);
void printTree2(TreeNode*);

#endif
