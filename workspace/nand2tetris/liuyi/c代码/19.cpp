#include<stdio.h>

int gcd(int a,int b){
    int c;
    if(a>=b){
        c=a%b;
        if(c==0) return b;
        else return gcd(b,c);
    }
    else{
        c=b%a;
        if(c==0) return a;
        else  return gcd(a,c);

    }

}

int main(){


    int n,i,a,b,num,A=0,B=1;
    scanf("%d",&n);
    for(i=0;i<n;i++){
        scanf("%d/%d",&a,&b);
        A=A*b+B*a;
        B*=b;
    }
    num=gcd(A,B);
    A=a/num;
    B=b/num/n;
      if(A%B==0)
        printf("%d",A/B);
    else
    printf("%d/%d",A,B);

    return 0;

}
