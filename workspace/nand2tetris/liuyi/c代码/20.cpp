#include<stdio.h>
#include<math.h>
int main(){
  int a ;
  long int n,sum=0;
  scanf("%d %d",&a,&n);
  for(int i=1;i<=n;i++){
    
    for(int j=i;j>0;j--){
      sum+=a*pow(10,j-1);
      
    }
    
  }
  printf("%ld",sum);
  return 0;
  
  
}
