/*Check whether the entered character is upper case, lower case, digit or any special character.*/
#include <stdio.h>
void main(){
    char ch;
    printf("Enter a Charachter : ");
    scanf("%c",&ch);
    if(ch>='a' && ch<='z'){
        printf("It is a Lowercase alphabet");
    }
    else if(ch>='A' && ch<='Z'){
        printf("It is a Uppercase alphabet");
    }
    else if(ch>='0' && ch<='9'){
        printf("It is a Digit number");
    }
    else{
        printf("It is a special charachter");
    }


}