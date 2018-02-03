#include <stdio.h>

int main() {
    int N=0,sum=0,i=0;
    int U;
    int D;
    scanf("%d %d %d",&N,&U,&D);
    while(1){
        i++;
        sum+=U;
        if(sum>=N)
            break;
        i++;
        sum-=D;

    }
    printf("%d",i);
    return 0;
}
