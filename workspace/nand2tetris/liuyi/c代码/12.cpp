#include<stdio.h>
int main(){
    int n,num;
    scanf("%d",&n);
    
    double b[101];
    b[1]=1;
    for (int i = 1; i <=99; ++i) {
        b[i+1]=1.0/(1+b[i]);
    }

    for (int j = 0; j < n; ++j) {
        scanf("%d",&num);
        printf("%.6lf\n",b[num]);
        
    }
    return 0;
}
