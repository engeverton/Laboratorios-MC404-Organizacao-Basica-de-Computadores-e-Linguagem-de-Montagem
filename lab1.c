#include <stdio.h>

int main(void) {
    char frase[6];
    int num1, num2;
    char operador;
    int soma, subtração, multiplicação, divisão;

    scanf("%[^\n]", frase);
    
    num1 = frase[0] - '0';
    num2 = frase[4] - '0';
    operador = frase[2];

    if (operador == '+') {
        soma = num1 + num2;
    }else if(operador == '-'){
        subtração = num1 - num2;
    }else if(operador == '*'){
        multiplicação = num1 * num2;
    }

    printf("%d/n", soma);

    return 0;
}