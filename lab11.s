.set LER_GPS, 0xFFFF0100 # Endereço para ler coordenadas
.set Z,    0xFFFF0118 # Endereço para coordenada Z
.set VOLANTE,  0xFFFF0120 # Endereço para direção do volante
.set MOTOR, 0xFFFF0121 # Endereço para ligar/desligar motor
.set FREIO,     0xFFFF0122 # Endereço para freios
.set LER_SENSOR, 0xFFFF0102   # Inicia leitura do sensor ultrassônico
.set DISTANCIA,  0xFFFF011C   # Valor da distância lida em cm

.align 2
.globl _start
_start:

    #Centraliza volante no início
    li t0, VOLANTE
    sb zero, 0(t0)

    # Liga motor
    li t0, MOTOR
    li t1, 1
    sb t1, 0(t0)

gira_direita:
    # Vira volante para a direita
    li t0, VOLANTE
    li t1, 20         
    sb t1, 0(t0)

    # Lê coordenadas
    li t0, LER_GPS
    li t1, 1
    sb t1, 0(t0)

espera_leitura1:
    lb t2, 0(t0)
    bnez t2, espera_leitura1

    # Lê coordenada Z
    li t0, Z
    lw t3, 0(t0)
    li t4, 130             
    blt t3, t4, gira_direita   # Enquanto Z < 130, continua girando para a direita

    # Centraliza volante
    li t0, VOLANTE
    sb zero, 0(t0)

    # Lê coordenadas novamente
    li t0, LER_GPS
    li t1, 1
    sb t1, 0(t0)

espera_leitura2:
    lb t2, 0(t0)
    bnez t2, espera_leitura2

    # Inicia leitura do sensor ultrassônico
    li t0, LER_SENSOR
    li t1, 1
    sb t1, 0(t0)

espera_sensor:
    lb t2, 0(t0)
    bnez t2, espera_sensor

    # Lê a distância medida
    li t0, DISTANCIA
    lw t6, 0(t0)

    li t5, 200       
    blt t6, t5, freia  # Se a distância for menor que 200 cm, freia   

# Parar carro
freia:
    li t0, MOTOR
    sb zero, 0(t0)

    li t0, FREIO
    li t1, 1
    sb t1, 0(t0)

    # Finaliza programa
    jal exit

exit:
    li a0, 0
    li a7, 93
    ecall
    ret
