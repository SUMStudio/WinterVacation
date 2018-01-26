#include <stdio.h>
#include <string.h>

int main()
{
    char s[100];
    char longest[100];
    int length=0;
    gets(s);
    while(strcmp(s,"***end***"))
    {
        if(length<strlen(s)){
            strcpy(longest,s);
            length=strlen(s);
            gets(s);
        }
    }
    printf("%d",length);
    puts(s);
    printf("\n");
    return 0;
}

