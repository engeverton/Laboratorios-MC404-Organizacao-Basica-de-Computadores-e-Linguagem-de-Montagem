.globl _start

_start:
    jal main    # chama a função main
    li a0, 0
    li a7, 93   # exit
    ecall

main:
    jal read # chama a função read para ler a string de entrada

    la t0, input_line    # t0 aponta para input_line
    li t1, 0             # contador para o primeiro número
    li t5, 32            # espaço em branco (ASCII 32)

# converter primeiro número para inteiro(ca1), até encontrar um espaço, e adiciona em t1
converter_inteiro_1:
    lbu s1, 0(t0)           # carrega primeiro byte e coloca em s1
    beq s1, t5, espaco      # verifica se é espaço e vai para a funçao espaco
    li t2, 10               # inicializa t2 com 10
    mul t1, t1, t2          # t1 *= 10
    addi s1, s1, -48        # transforma s1 em inteiro subtraindo 48 da tabela ascii    
    add t1, t1, s1          # adiciona o valor em inteiro no contador t1
    addi t0, t0, 1          # incrementa o ponteiro, para ir para o próximo caractere
    j converter_inteiro_1   # volta para converter o próximo caractere

# quando encontra o espaço, incrementa 1 para o próximo caractere
espaco:
    addi t0, t0, 1 

# converter segundo número (co1), até encontrar um '\n' e adicionar em s8
li s8, 0    # contador para o primeiro número        
li t6, 10   # '\n' (ASCII 10)
converter_inteiro_2:
    lbu s2, 0(t0)           # carrega primeiro byte e coloca em s2
    beq s2, t6, pulou       # verifica se é um '\n' e vai para a funçao 'pulou' 
    li t2, 10               # inicializa t2 com 10
    mul s8, s8, t2          # s8 *= 10
    addi s2, s2, -48        # transforma s2 em inteiro subtraindo 48 da tabela ascii
    add s8, s8, s2          # adiciona o valor em inteiro no contador s8
    addi t0, t0, 1          # incrementa o ponteiro, para ir para o próximo caractere
    j converter_inteiro_2   # volta para converter o próximo caractere

# quando encontra um '\n', incrementa 1 para o próximo caractere, na próxima linha
pulou:
    addi t0, t0, 1

# converter terceiro número/número da segunda linha de entrada (co2), até encontra um '\n' e adicionar em s7
li s7, 0    # contador para o primeiro número 
li t6, 10   # '\n' (ASCII 10)
converter_inteiro_3:
    lbu s3, 0(t0)                       # carrega primeiro byte e coloca em s3
    beq s3, t6, formula_de_similaridade # verifica se é um '\n' e vai para a funçao 'formula_de_similaridade' 
    li t2, 10                           # inicializa t2 com 10
    mul s7, s7, t2                      # s7 *= 10
    addi s3, s3, -48                    # transforma s3 em inteiro subtraindo 48 da tabela ascii
    add s7, s7, s3                      # adiciona o valor em inteiro no contador s7
    addi t0, t0, 1                      # incrementa o ponteiro, para ir para o próximo caractere
    j converter_inteiro_3               # volta para converter o próximo caractere

formula_de_similaridade:
    mul s4, t1, s7       # t1 = ca1 * s7 = co2
    div s5, s4, s8       # resultado = (s4 = ca1 * co2) / s8 =co1

# converte o resultado da formula para string e coloca na saída
conversao_p_string:
    la t3, result       # t3 aponta para result

    mv t4, s5           # copia o resultado para não perder
    li t2, 10
    div t5, t4, t2      # t5 = dezena
    rem t6, t4, t2      # t6 = unidade

    beqz t5, unidade    # verifica se t5 é igual a 0, que se for é um número com apenas uma unidade, e pula para a função 'unidade'

    # converte o algarismo da dezena
    addi t5, t5, 48 
    sb t5, 0(t3)

    # converte o algarismo da unidade
    addi t6, t6, 48
    sb t6, 1(t3)

    # adiciona o caractere de nova linha no buffer
    li s10, 10
    sb s10, 2(t3)

    # chama a função write para escrever o resultado na saída padrão
    jal write
    ret

# funcão para converte apenas uma unidade e colocar na saída padrão
unidade:

    # converte o algarismo da unidade
    addi t6, t6, 48
    sb t6, 0(t3)

    # adiciona o caractere de nova linha no buffer
    li s10, 10
    sb s10, 1(t3)

    # chama a função write para escrever o resultado na saída padrão
    jal write
    ret

read:
    li a0, 0           # file descriptor = 0 (stdin)  
    la a1, input_line  # buffer
    li a2, 8           # size - Reads 8 bytes.
    li a7, 63          # syscall read (63)  
    ecall
    ret

write:
    li a0, 1           # file descriptor = 1 (stdout
    la a1, result      # buffer 
    li a2, 3           # size - Writes 4 bytes.
    li a7, 64          # syscall write (64) 
    ecall
    ret

.bss
input_line: .skip 0x8  #buffer de entrada de 8 bytes
result:       .skip 0x3  # buffer de saída de 3 bytes
