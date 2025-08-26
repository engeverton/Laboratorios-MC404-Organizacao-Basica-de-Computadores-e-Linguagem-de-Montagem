#include <stdio.h>

// Função para converter a string para um número sem sinal
unsigned int binario_para_inteiro(char binario[]) {
    unsigned int numero = 0;
    for (int i = 0; i < 32; i++) {
        numero = (numero << 1) | (binario[i] - '0');
    }
    return numero;
}

// Função para inverter a ordem dos bytes 
unsigned int inverter(unsigned int numero) {
    return ((numero >> 24) & 0xFF) | ((numero >> 8) & 0xFF00) | ((numero << 8) & 0xFF0000) | ((numero << 24) & 0xFF000000); 
}

int main() {
    char entrada[33];  // String para armazenar a entrada, de 32 bits + \0
    scanf("%s", entrada);

    // Converter string binária para número sem sinal
    unsigned int numero = binario_para_inteiro(entrada);

    // Interpretar como número com sinal (complemento de dois)
    int numero_com_sinal = (int)numero;

    // Trocar endianness
    unsigned int numero_invertido = inverter(numero);
    int numero_com_sinal_invertido = (int)numero_invertido;

    printf("%d\n", numero_com_sinal);                 // Decimal
    printf("%u\n", numero_invertido);                 // Decimal sem sinal
    printf("0x%X\n", numero);                         // Hexadecimal
    printf("0o%o\n", numero);                         // Octal
    printf("0b%s\n", entrada);                        // Binário
    printf("%d\n", numero_com_sinal_invertido);       // Decimal complemento de dois - trocado
    printf("0x%X\n", numero_invertido);               // Hexadecimal - trocado
    printf("0o%o\n", numero_invertido);               // Octal - trocado

    return 0;
}
