// 2022/2023 autumn
// This was a final project for the course, where we had to implement a reverse command. The base of the task was the rev Unix utility, which prints the contents of the input(s) in the original order, but without line numbers and with the lines reversed.

// 2022/2023 ősz
// Ez egy év végi beadandó feladat volt, melyben egy reverse parancssori parancsot kellet megvalósítani. A feladat alapja a rev Unix utility, amely a kapott bemenet(ek) tartalmát eredeti sorrendben, de sorszámozás nélkül és a sorokat megfordítva írja ki.

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