.globl _start

_start:
    jal main    # chama a função main

#termina o programa
final:
    li a0, 0
    li a7, 93   # exit
    ecall

main:
    jal read                # chama a função read para ler a string de entrada
    la t0, input_line       # t0 aponta para input_line que é o buffer de entrada
    li t3, 10               # t3 = 10 -> indica que é um '\n' em ascii
    li s2, 0                # acumulador para número da primeira linha

# Lê o sinal da primeira linha e adiciona em s1
le_sinal1:
    lb s1, 0(t0)
    addi t0, t0, 2          # depois de ler o sinal incrementa 2 ao ponteiro, para pular a linha em branco
# Converte o número da primeira linha e armazena em s2
converter_n1:
    lb t4, 0(t0)            # carrega primeiro byte e coloca em t4
    beq t4, t3, pulou_1     # se for um \n, vai para a função 'pulou_1'
    li s7, 10               # inicializa s7 com 10
    mul s2, s2, s7          # s2 *= 10
    addi t4, t4, -48        # transforma t4 em inteiro subtraindo 48 da tabela ascii
    add s2, s2, t4          # adiciona o valor em inteiro no acumulador s2
    addi t0, t0, 1          # incrementa o ponteiro, para ir para o próximo caractere
    j converter_n1          # volta para converter o próximo caractere, se tiver

    # quando encontra um '\n', incrementa 1 para o próximo caractere
    pulou_1:
        addi t0, t0, 1
        li s4, 0            # acumulador para número da segunda linha

# Lê o sinal da segunda linha e adiciona em s3
le_sinal2:
    lb s3, 0(t0)
    addi t0, t0, 2
# Converte o número da segunda linha e armazena em s4
converter_n2:
    lb t5, 0(t0)            # carrega primeiro byte e coloca em t4
    beq t5, t3, pulou_2     # se for um \n, vai para a função 'pulou_2'
    li s7, 10               # inicializa s7 com 10
    mul s4, s4, s7          # s4 *= 10
    addi t5, t5, -48        # transforma t5 em inteiro subtraindo 48 da tabela ascii
    add s4, s4, t5          # adiciona o valor em inteiro no acumulador s4
    addi t0, t0, 1          # incrementa o ponteiro, para ir para o próximo caractere
    j converter_n2          # volta para converter o próximo caractere, se tiver

    # quando encontra um '\n', incrementa 1 para o próximo caractere
    pulou_2:
        addi t0, t0, 1
        li s6, 0            # acumulador para número da terceira linha

# Lê o sinal da terceira linha e adiciona em s5
le_sinal3:
    lb s5, 0(t0)
    addi t0, t0, 2
# Converte o número da terceira linha e armazena em s6
converter_n3:
    lb t6, 0(t0)            # carrega primeiro byte e coloca em t6
    beq t6, t3, pulou_3     # se for um \n, vai para a função 'pulou_3'
    li s7, 10               # inicializa s7 com 10
    mul s6, s6, s7          # s6 *= 10
    addi t6, t6, -48        # transforma t6 em inteiro subtraindo 48 da tabela ascii
    add s6, s6, t6          # adiciona o valor em inteiro no acumulador s6
    addi t0, t0, 1          # incrementa o ponteiro, para ir para o próximo caractere
    j converter_n3          # volta para converter o próximo caractere, se tiver

    # quando encontra um '\n', incrementa 1 para o próximo caractere
    pulou_3:
        addi t0, t0, 1
        li t1, 0            # acumulador para o primeiro número da quarta linha (a)
        li s9, 32           # s9 = 32 -> indica que é um espaco em ascii

# converte os limites da intergral a -> t1, b -> t2
# converte o primeiro número da quarta linha (a)
converter_linha4_n1:
    lb s8, 0(t0)            # carrega primeiro byte e coloca em s8
    beq s8, s9, espaco      # se for um espaco, vai para a função 'espaco'
    li s7, 10               # inicializa s7 com 10
    mul t1, t1, s7          # t1 *= 10
    addi s8, s8, -48        # transforma s8 em inteiro subtraindo 48 da tabela ascii
    add t1, t1, s8          # adiciona o valor em inteiro no acumulador t1
    addi t0, t0, 1          # incrementa o ponteiro, para ir para o próximo caractere
    j converter_linha4_n1   # volta para converter o próximo caractere, se tiver

    # quando encontra um espaco, incrementa 1 para o próximo caractere
    espaco:
        addi t0, t0, 1     
        li t2, 0            # acumulador para o segundo número da quarta linha (b)
        li s9, 10

    # converte o segundo número da quarta linha (b)
    converter_linha4_n2:
        lb s10, 0(t0)           # carrega primeiro byte e coloca em s8
        beq s10, s9, integral   # se for um '\n', vai para a função itegral
        li s7, 10               # inicializa s7 com 10
        mul t2, t2, s7          # t2 *= 10
        addi s10, s10, -48      # transforma s10 em inteiro subtraindo 48 da tabela ascii
        add t2, t2, s10         # adiciona o valor em inteiro no acumulador t2
        addi t0, t0, 1          # incrementa o ponteiro, para ir para o próximo caractere
        j converter_linha4_n2   # volta para converter o próximo caractere, se tiver

# Faz o cáculo da integral 
integral:
    li s11, 0                   
    addi s2, s2, 1              # adicioma 1 ao primeiro expoente
    addi s4, s4, 1              # adicioma 1 ao segundo expoente
    addi s6, s6, 1              # adicioma 1 ao terceiro expoente

# coloca o expoente em a1, e o sinal em a7, e chama a funcao exponenciacao, 
# faz isso para os valores de cada linha da entrada
# depois incrementa o resultado (retorno da funcao s10) em s11
    mv a1, s2
    mv a7, s1
    jal exponenciacao
    add s11, s11, s10

    mv a1, s4
    mv a7, s3
    jal exponenciacao
    add s11, s11, s10

    mv a1, s6
    mv a7, s5
    jal exponenciacao
    add s11, s11, s10


#######transforma o resultado s11 em string para imprimir na saída
conversao_p_string:
    la t6, result         # t6 aponta para result, que é a saída
    li t1, 10             # t1 = 10
    li t3, 0              # contador de dígitos

contrario:
    rem t0, s11, t1       # extrai o último dígito
    addi t0, t0, 48       # converte para ASCII
    sb t0, 0(t6)          # coloca no primeiro byte da saída
    addi t6, t6, 1        # incrementa 1 para converter o próximo dígito
    addi t3, t3, 1        # incrementa o contador
    div s11, s11, t1      # remove o último dígito que já foi convertido
    bnez s11, contrario   # se não for igual a 0, ainda tem mais dígitos 
                          # para converter e continua o loop

# Inverte os dígitos pois foram colocados no vetor do último para o primeiro
    la t0, result        # t0 aponta para o início do buffer result
    addi t6, t6, -1      # t6 aponta para o último caractere preenchido
inverte:
    bge t0, t6, finaliza_com_nova_linha  
    lb t1, 0(t0)
    lb t2, 0(t6)
    sb t2, 0(t0)
    sb t1, 0(t6)
    addi t0, t0, 1
    addi t6, t6, -1
    j inverte

# adiciona quebra de linha e nulo no final e depois chama 'write'
finaliza_com_nova_linha:
    la t6, result         # t6 aponta para o início de 'result'
    add t6, t6, t3        # aponta para fim da string pois soma t3 que é o contador de dígitos
    li t0, 10          
    sb t0, 0(t6)
    addi t6, t6, 1
    li t0, 0
    sb t0, 0(t6)
    jal write            # chama a funcao write para imprimir         
    j final              # chama final para terminar o programa
 
# calcula a exponenciação com o expoente de cada linha
exponenciacao:
        # exponenciacao com a base a -> t1
        mv a0, t1           # base - a -> t1
        li a2, 1            # resultado = 1 que vai ser acumulado
        li a3, 0            # contador inicialmente igual a 0

    loop1:
        beq a3, a1, base_b  # se contador == expoente (a1), termina
        mul a2, a2, a0      # resultado *= base
        addi a3, a3, 1      # contador++
        j loop1

    # exponenciacao com a base b -> t2
    base_b:
        mv a5, t2           # base - b -> t2
        li a4, 1            # resultado = 1 que vai ser acumulado
        li a3, 0            # contador inicialmente igual a 0

    loop2:
        beq a3, a1, calculos    # se contador == expoente (a1), termina
        mul a4, a4, a5          # resultado *= base
        addi a3, a3, 1          # contador++
        j loop2

# faz os calculos da integral
calculos:
    div a2, a2, a1     # a = a/a1  
    div a4, a4, a1     # b = b/a4
    sub s10, a2, a4    # resultado s10 = a - b

    # verifica se o sinal é negativo, e se for, multiplica o resultado (s10) por -1, 
    # e retorna para a instrucao seguinte de onde foi chamado, isso dentro da funcao integral
    sinal:
        li t3, 43
        beq a7, t3, negativo
        ret
        
        negativo:
            li s9, -1
            mul s10, s10, s9
            ret


read:
    li a0, 0           # file descriptor = 0 (stdin)  
    la a1, input_line  # buffer de entrada
    li a2, 24          # size - Reads 24 bytes.
    li a7, 63          # syscall read (63)  
    ecall
    ret

write:
    li a0, 1           # file descriptor = 1 (stdout
    la a1, result      # buffer de saída
    li a2, 20          # size - Writes 20 bytes.
    li a7, 64          # syscall write (64) 
    ecall
    ret

.bss
input_line: .skip 0x18  #buffer de entrada de 24 bytes 0x18
result:      .skip 0x14  # buffer de saída de 20 bytes  0x14












