#include<stdio.h>
void main(){
	int s;
	printf("Enter the number of seconds : ");
	scanf("%d",&s);
	if(s<60){
		printf("00:00:%02d",s);
	}
	else if(s>=60 && s<3600){
		printf("00:%02d:%02d",s/60,s%60);
	}
	else if(s>=3600){
		printf("%02d:%02d:%02d",s/3600,(s%3600)/60,((s%3600)/60)%60);
	}
}
