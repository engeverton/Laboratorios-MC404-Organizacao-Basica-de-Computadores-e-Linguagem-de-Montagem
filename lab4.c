int read(int __fd, const void *__buf, int __n){
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall write code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)  // Output list
    : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return ret_val;
}

void write(int __fd, const void *__buf, int __n)
{
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

void exit(int code)
{
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}

#define STDIN_FD  0
#define STDOUT_FD 1

int operacao(char str[], int inicio_1, int fim_1,int inicio_2, int fim_2, char operador){
    // Converte os dois números (num1 e num2) de string para inteiro
    int num1 = 0, num2 = 0, novo_num;
    for (int i = (inicio_1 + 1) ; i <= fim_1; i++){
        num1 = num1 * 10 + (str[i] - '0');
    }

    for (int i = (inicio_2 + 1) ; i <= fim_2; i++){
        num2 = num2 * 10 + (str[i] - '0');
    }

    // Verifica se o sinal é negativo e se for, transforma o número em negativo
    if(str[inicio_1] == '-'){
        num1 = -num1;
    }

    if(str[inicio_2] == '-'){
        num2 = -num2;
    }

    // Realiza a operação de acordo com o operador
    // 'a' = and, 'o' = or, 'x' = xor, 'n' = nand
    if (operador == 'a'){
        novo_num = num1 & num2;
    }else if(operador == 'o'){
        novo_num = num1 | num2;
    }else if(operador == 'x'){
        novo_num = num1 ^ num2;
    }else if(operador == 'n'){
        novo_num = ~(num1 & num2);
    }

    return novo_num;
}

//Função que converte um número inteiro para hexadecimal e imprime
void hex_code(int val){
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;

    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(1, hex, 11);
}

#define STDIN_FD  0
#define STDOUT_FD 1

int main()
{
    // Lê a string de entrada
    char str[48];
    int tam_str = read(STDIN_FD, str, 48);
    
    
    int n1, n2, n3, n4, valor_hex = 0;

    // Realiza as operações lógicas
    n1 = operacao(str, 0, 4, 6, 10, 'a'); //and
    n2 = operacao(str, 12, 16, 18, 22, 'o'); //or
    n3 = operacao(str, 24, 28, 30, 34, 'x'); //xor
    n4 = operacao(str, 36, 40, 42, 46, 'n'); // nand

    //agrupa os 4 números
    //n1 => pega o byte menos significativo de n1 e coloca no byte 0
    //n2 => pega o byte menos significativo de n2 e coloca no byte 1
    //n3 => pega o byte mais significativo de n3 e coloca no byte 2
    //n4 => pega o byte mais significativo de n4 e coloca no byte 3
    valor_hex = (n1 & 255) | ((n2 & 255) << 8) | ((n4 >> 24) & 255) << 16 | ((n3 >> 24) & 255) << 24;

    hex_code(valor_hex);
    return 0;
}