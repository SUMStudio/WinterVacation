#include <stdio.h>
#include <string.h>
#include <ctype.h>
char str[110];
char cmp[110];
int main()
{
    int caps,n;
    scanf("%s",str);
    scanf("%d%d",&caps,&n);
    if(caps==0){
        for(int i=0;i<strlen(str);i++)
            str[i]=toupper(str[i]);
    }
    for(int i=1;i<=n;i++)
    {
        scanf("%s",cmp);
        char copycmp[100];
        strcpy(copycmp,cmp);
        if(caps==0){
        for(int i=0;i<strlen(cmp);i++)
            copycmp[i]=toupper(cmp[i]);
        }
        if(strstr(copycmp,str)!=NULL)printf("%s\n",cmp);
    }
    return 0;

}

