#include<stdio.h>

int gcd(int a,int b){

        if(b==0) return a;
        int c=a%b;
        return gcd(b,c);
}


int main(){
    int a,b,c;
    while(1)
    {

        scanf("%d %d", &a, &b);
        c = gcd(a, b);
        if(c!=0)
        printf("%d\n", c);
        else
            printf("Done\n");
            break;
    }
    return 0;
}
