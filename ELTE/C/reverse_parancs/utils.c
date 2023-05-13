#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "utils.h"

void fileWrite(char **output, char *lines)
{
    FILE *fp = fopen("output.txt", "w");
    int i = arrSize(output);
    if (strcmp(lines, "nolinenums") == 0)
    {
        while (i > 0)
        {
            if (i != 1)
            {
                fprintf(fp, "%s\n", output[i - 1]);
            }
            else
            {
                fprintf(fp, "%s", output[i - 1]);
            }
            i--;
        }
    }
    else{
        while (i > 0)
        {
            if (i != 1)
            {
                fprintf(fp, "%d %s\n", i, output[i - 1]);
            }
            else
            {
                fprintf(fp, "%d %s", i, output[i - 1]);
            }
            i--;
        }
    }
    fclose(fp);
}

void fixLine(char *p)
{
    while (*p != '\0' && *p != '\r' && *p != '\n')
    {
        p++;
    }
    *p = '\0';
}

void reverseWord(char *p)
{
    char *temp = (char *)malloc(strlen(p) * sizeof(char));
    int j = strlen(p) - 1;
    while (j > 0)
    {
        strcpy(temp, (p + j));
        *(p + j) = *p;
        *p = *temp;
        p++;
        j -= 2;
    }
    free(temp);
}

int arrSize(char **output)
{
    int i = 0;
    while (output[i] != NULL)
        i++;
    return i;
}

char **read(FILE *fp, char *output[], int buffer, int size, int maxSize)
{
    char *ch = malloc(sizeof(char) * buffer);
    while (fgets(ch, buffer, fp) != NULL)
    {
        if (size == maxSize)
        {
            maxSize *= 2;
            output = realloc(output, maxSize * sizeof(char *));
            memcheck(output);
        }
        fixLine(ch);
        reverseWord(ch);
        output[size] = (char *)malloc(sizeof(char) * buffer);
        strcpy(output[size], ch);
        size++;
    }
    free(ch);
    return output;
}

void memcheck(void *p)
{
    if (p == NULL)
    {
        fprintf(stderr, "Memory allocation failed!\n");
        exit(1);
    }
}