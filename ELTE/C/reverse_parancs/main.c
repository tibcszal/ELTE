// 2022/2023 autumn
// This was a final project for the course, where we had to implement a reverse command. The base of the task was the rev Unix utility, which prints the contents of the input(s) in the original order, but without line numbers and with the lines reversed.

// 2022/2023 ősz
// Ez egy év végi beadandó feladat volt, melyben egy reverse parancssori parancsot kellet megvalósítani. A feladat alapja a rev Unix utility, amely a kapott bemenet(ek) tartalmát eredeti sorrendben, de sorszámozás nélkül és a sorokat megfordítva írja ki.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "utils.h"

int main(int argc, char *argv[])
{
    if (strcmp(argv[1], "linenums") != 0 && strcmp(argv[1], "nolinenums") != 0)
    {
        fprintf(stderr, "First argument invalid, expected 'linenums' or 'nolinenums'\n");
        return 1;
    }
    if (argc < 3)
    {
        fprintf(stderr, "Usage:\n\trev [SHOW LINE NUMBERS] [MAX LINE LENGTH] files...\n");
        return 1;
    }

    BasicInfo *data = malloc(sizeof(BasicInfo));
    memcheck(data);
    data->lineNums = argv[1];
    data->buffer = atoi(argv[2]);

    int num_lines = 8;
    char **output = (char **)malloc(num_lines * sizeof(char *));
    memcheck(output);
    int size = 0;

    if (argc == 3)
    {
        output = read(stdin, output, data->buffer, size, num_lines);
        fileWrite(output, data->lineNums);
        free(data);
        return 0;
    }

    for (int i = 3; i < argc; i++)
    {
        FILE *fp = fopen(argv[i], "r");
        size = arrSize(output);
        if (fp != NULL)
        {
            output = read(fp, output, data->buffer, size, num_lines);
            fclose(fp);
        }
        else
        {
            fprintf(stderr, "File opening unsuccessful: %s\n", argv[i]);
        }
    }
    fileWrite(output, data->lineNums);
    free(data);
    int j = 0;
    while (output[j] != NULL)
    {
        free(output[j]);
        j++;
    }
    free(output);

    return 0;
}