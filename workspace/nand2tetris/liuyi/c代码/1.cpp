/*
����Ҫ��ʵ������������һ�������жϸ����������ĸ�λ����֮���Ƿ����5��
��һ������ͳ�Ƹ����������ж��� ����������Ҫ�����������������Щ�����ĺ͡�*/
#include <stdio.h>

int is( int number ){
    int sum=0;
    while (number){
        int ans=number%10;
        sum+=ans;
        number/=10;
    }
    if(sum==5){
        return 1;
    }
    else return 0;

}
void count_sum( int a, int b ){

    int count=0;int sun=0;

    for (int i = a; i <=b ; ++i) {
                if(is(i)){
                    count++;
                    sun+=i;
                }
    }
    printf("count = %d, sun=%d",count,sun);
}

int main()
{
    int a, b;

    scanf("%d %d", &a, &b);
    if (is(a)) printf("%d is counted.\n", a);
    if (is(b)) printf("%d is counted.\n", b);
    count_sum(a, b);

    return 0;
}

