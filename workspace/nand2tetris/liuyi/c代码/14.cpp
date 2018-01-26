
#include<stdio.h>

int sushu(int num){
    for (int i = 2; i <= num/2; ++i) {
        if (num%i==0) return 0;
    }
    return 1;
}
int main(){
    int b[51],n;
    b[1]=1;b[2]=1;
    for (int i = 2; i <50; ++i) {
        b[i+1]=b[i]+b[i-1];
    }
    scanf("%d",&n);
    int flag=sushu(b[n]);
    if(flag==1) printf("yes");
    else printf("%d",b[n]);
return 0;

}
