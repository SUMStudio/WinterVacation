#include<stdio.h>


int main(){
    long int a ,n=0;
    scanf("%d",&a);
    if(a==0){
    printf("%d %d %d",0,0,0);
    }
    
    else{
    
    int ca=a;
    while(ca){
        n++;
         ca/=10;
    }

    int max=a%10,min=a%10;
    a/=10;

    for (int i = 0; i <n-1; ++i) {
        int tep=a%10;
        if(tep>=max) max=tep;
        if(tep<=min) min=tep;
        a/=10;

    }
    printf("%d %d %d",n,max,min);
    }

return 0;
}
