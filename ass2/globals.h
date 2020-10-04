#ifndef _GLOBALS_H_
#define _GLOBALS_H_

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "scanType.h"

#define MAXCHILDREN 3

typedef enum {DeclK, StmtK, ExpK} NodeKind;
typedef enum {VarK, FuncK, ParamK} DeclKind;
typedef enum {NullK, IfK, WhileK, CompoundK, ReturnK, ForK, BreakK} StmtKind;
typedef enum {OpK, ConstantK, IdK, AssignK, InitK, CallK} ExpKind;
typedef enum {Void, Integer, Boolean, Char, CharInt, Equal, UndefinedType, String} ExpType;
typedef int OpKind;

typedef struct treeNode
{
    // connectivity in the tree
    struct treeNode *child[MAXCHILDREN];   // children of the node
    struct treeNode *sibling;              // siblings for the node

    // what kind of node
    int lineno;                            // linenum relevant to this node
    NodeKind nodekind;                     // type of node
    union                                  // subtype of type
    {
	DeclKind decl;                     // used when DeclK
	StmtKind stmt;                     // used when StmtK
	ExpKind exp;                       // used when ExpK
    } kind;

    // extra properties about the node depending on type of the node
    union                                  // relevant data to type -> attr
    {
        OpKind op;                         // type of token (same as in bison)
	int value;                         // used when an integer constant or boolean
        unsigned char cvalue;              // used when a character
	char *string;                      // used when a string constant
	char *name;                        // used when IdK
    } attr;
    ExpType expType;		           // used when ExpK for type checking
    bool isArray;                          // is this an array
    bool isStatic;                         // is staticly allocated?

    // even more semantic stuff will go here in later assignments.
} TreeNode;
#endif
