#ifndef _SCANTYPE_H_
#define _SCANTYPE_H_

//
// SCANNER TOKENDATA
//

struct TokenData {
    int tokenClass;     // token class
    int lineNum;        // line where found
    char *tokenStr;     // what string was actually read
    char cValue;        // any character value
    int nValue;         // any numeric value or Boolean value
    char *sValue;       // any string value e.g. an id
};
#endif
