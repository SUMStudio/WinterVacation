#include<stdio.h>
#include<stdlib.h> 
#include<string.h>

int main(){
	char s[100];
	scanf("%s",s);
	int i=0;
	while(s[i]!='\0'){
		if(s[i]<'0'||s[i]>'9'){
		putchar(s[i]);
		i++;
		}
		
		else{
			int k=0,sum=0;
			while(s[i+k]>'0'&&s[i+k]<'9'){
				sum=sum*10+(s[i+k]-'0');
				k++;
			}
			sum--;
			while(sum--){
				putchar(s[i-1]);
			}
			i=i+k;
			
		}
		
		
	}
	return 0;
}
