#include<stdio.h>
int main(){
    double  num;
    double wage;
    scanf("%lf",&num);
    if(num<=110){
        wage=num*0.5;
    }
    else if(num<=210){
        wage=55+(num-110)*0.55;
    }
    else{
        wage=110+(num-210)*0.75;
    }
    printf("%.2lf",wage);

    return 0;

}
