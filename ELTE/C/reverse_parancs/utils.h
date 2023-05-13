#ifndef UTILS_H_INCLUDED
#define UTILS_H_INCLUDED

typedef struct BasicInfo
{
    char *lineNums;
    int buffer;
} BasicInfo;

void reverseWord(char *p);
void fixLine(char *p);
void fileWrite(char **output, char *lines);
char **read(FILE *fp, char *output[], int buffer, int size, int maxSize);
void memcheck(void *p);
int arrSize(char **output);

#endif