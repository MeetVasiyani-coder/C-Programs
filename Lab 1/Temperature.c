#include <stdio.h>
void main(){
	float f;
	printf("Enter the temperature in fahrenheit : ");
	scanf("%f",&f);
	printf("Temperature in Celsius = %f ",(((f-32)*5))/9);
	
}
