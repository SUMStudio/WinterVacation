#include<stdio.h>
#include<string.h>

int main(){
	int num,i=0,count=0;

	char name,str[100]={0};
	scanf("%c %d",&name,&num);
	scanf("%s",str);
		int length=strlen(str);
	if(num==0){
		if(name>'A'&&name<'Z'){
			name+=32;
		}
		while(i<length){
			if(str[i]==name||str[i]==(name-32)){
				count++;
			}
			i++;
		}
   }

   if(num==1){
		while(i<length){
			if(str[i]==name){
				count++;
			}
			i++;
       }
    }

    printf("%d\n",count);
	return 0;

}


