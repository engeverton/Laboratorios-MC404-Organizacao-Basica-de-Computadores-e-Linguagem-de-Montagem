.globl _start

_start:
    jal main   # chama a função main
    li a0, 0
    li a7, 93 # exit
    ecall


main:
    jal read # chama a função read para ler a string de entrada

#converte a entrada de string para inteiro e calcula o tamanho dos catetos
calculo_de_catetos:
    la t0, input_address   #t0 aponta para input_adress
    li t4, 10 #inicializa t4 com 10

    #converte  o x(s1t1) da coordenada A para inteiro
    lbu s1, 1(t0) #carrega primeiro byte e coloca em s1
    addi s1, s1, -48 #transforma s1 em inteiro subtraindo 48 da tabela ascii
    mul s1, s1, t4 # multiplica por 10 pois é o algarismo das dezenas
    lbu t1, 2(t0) #carrega segundo byte e coloca em t1
    addi t1, t1, -48 #transforma t1 em inteiro subtraindo 48 da tabela ascii
    add s1, s1, t1 #como é o algarismo das unidades, soma os dois valores


    #converte o x(s2t1) da coordenada B para inteiro
    lbu s2, 9(t0)
    addi s2, s2, -48
    mul s2, s2, t4
    lbu t1, 10(t0)
    addi t1, t1, -48
    add s2, s2, t1

    #converte o y(s3t1) da coordenada B para inteiro
    lbu s3, 12(t0)
    addi s3, s3, -48
    mul s3, s3, t4
    lbu t1, 13(t0)
    addi t1, t1, -48
    add s3, s3, t1

    #converte o y(s4t1) da coordenada C para inteiro
    lbu s4, 20(t0)
    addi s4, s4, -48
    mul s4, s4, t4
    lbu t1, 21(t0)
    addi t1, t1, -48
    add s4, s4, t1


    sub s1, s2, s1  #calcula o cateto_x (s1) = xb(s2) - xa(s1)
    sub s3, s4, s3  #calcula o cateto_y (s3 )= yc(s4) - ya(s3)
    

    mul s1, s1, s1  #quadrado do cateto x (s1)
    mul s3, s3, s3  #quadrado do cateto y (s3)
    add s5, s1, s3  #soma dos quadrados dos catetos x(s1) e y(s2), segundo o teorema de pitagoras
                    #para descobrir a hipotenusa 

    #estimativa inicial usando o método babilônico para calcular a raiz quadrada de s5
    slli s6, s5, 1 //desloca 1 bit a esquerda que multiplica por 2 
    li s7, 0 #contador da iteracao

#calcula a raiz quadrada usando o método babilônico
metodo_babilonico:
    beq s7, t4, conversao_p_string  #se o contador(s7) for igual a 10, sai do loop e vai para a conversao_p_string
    div s8, s5, s6   #s8 = y/k
    add s6, s6, s8   #s6 = k + y/k
    srai s6, s6, 1   #s6 = (k + y/k)/2, desloca 1 bit a direita, que divide por 2
    addi s7, s7, 1   #soma 1 ao contador
    j metodo_babilonico # volta para o loop

#converte o valor da raiz quadrada(s6) em string
conversao_p_string:
    la t2, result   //t2 aponta para a saída result
    li t1, 100   //t1 = 100, usado para dividir a raiz quadrada e transformar em string

    #trandforma a centena da raiz quadrada(s6) em string e adicionar ao buffer
    div s9, s6, t1 #divide a raiz quadrada(s6) por 100, e coloca em s9
    rem s6, s6, t1 #pega o resto da divisão de s6 por 100, e coloca em s6
    addi s9, s9, 48 # transforma em string usando a tabela ascii
    sb s9, 0(t2) #escreve o valor no primeiro byte do buffer

    #transforma a dezena da raiz quadrada(s6) em string e adiciona ao buffer
    div s10, s6, t4
    rem s6, s6, t4
    addi s10, s10, 48
    sb s10, 1(t2)

    #transforma a unidade da raiz quadrada(s6) em string e adiciona ao buffer
    addi s6, s6, 48
    sb s6, 2(t2)

    #adiciona o caractere de nova linha no buffer
    li s11, 10  #caractere de nova linha representado pelo 10 na tabela ascii
    sb s11, 3(t2)

    jal write # chama a função write para escrever o resultado na saída padrão
    ret 


read:
    li a0, 0             # file descriptor = 0 (stdin)
    la a1, input_address # buffer
    li a2,             # size - Reads 24 bytes.
    li a7, 63            # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result       # buffer
    li a2, 4            # size - Writes 4 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret


.bss
input_address: .skip 0x18  # buffer de 24 bytes
result: .skip 0x4  # buffer de saída de 4 bytes