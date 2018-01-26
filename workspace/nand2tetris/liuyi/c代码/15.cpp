#include<stdio.h>
#include<stdlib.h>



int main(){
	
	double arr[100];
	arr[0]=1;arr[1]=2;
	for(int i=2;i<=100;i++){
		arr[i]=arr[i-1]+arr[i-2];
		
	}
	
	int n;
	double sum=0;
	scanf("%d",&n);
	for(int i=0;i<n;i++){
		sum+=arr[i+1]/arr[i];
	}
	printf("%.2lf",sum);
	
	
	return 0; 	
} 
