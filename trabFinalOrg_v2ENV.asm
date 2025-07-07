	.data
menu:	.asciz	"\n Menu: \n 1) Configuração \n 2) Jogar \n 3) Sair \n"
opc:	.asciz "Digite o numero da opcao: "
cfg:	.asciz "\n 1) Quantidade de jogadores \n 2) Tamanho da tabuleiro \n 3) Dificuldade \n 4) Zerar contadores \n 5) Configs atuais e valor dos contadores \n" 
cfg_player:	.asciz "Escolha 1 ou 2 jogadores: \n "
cfg_board:	.asciz "Escolha o número de colunas do tabuleiro: \n 7 ou 9  \n "
cfg_diff:	.asciz "Selecione a dificuldade: \n 1) Fácil \n 2) Aleatório \n "
cfg_zero:	.asciz "Os contadores foram zerados \n "
cfg_show:	.asciz "Configurações atuais: \n "
cfg_show_player:	.asciz "Número de jogadores: \n "
cfg_show_board:		.asciz "\n Tamanho do tabuleiro: \n "
cfg_show_diff:		.asciz "\n Nível de dificuldade [1] Fácil [2] Aleatório: \n "
newline:    .asciz "\n"
pipe:       .asciz "|"
underline: .asciz " _ "
xyz6:	    .asciz "x6"
msg1:	.asciz "O jogador"
msg2:	.asciz "venceu!!! \n"
msg3:	.asciz "Insira a coluna para jogar:"

cnn:	.word 199
var1:	.word 1
var2:	.word 2
var3:	.word 3
var4:	.word 4
var5:	.word 5
var7:	.word 7
var9:	.word 9

.align 4

board:	.space 216


	.text
	DEFAULT:
li s0, 2
li s1, 7
li s2, 1
li s3, 0
li s4, 0

	INICIO:	
LI a7,4
LA a0,menu
ECALL
LA a0, opc
ECALL
LI a7, 5
ECALL

LA t1, var1
LW t1, 0(t1)
LA t2, var2
LW t2, 0(t2)
LA t3, var3
LW t3, 0(t3)

BEQ a0, t1, CONFIG
BEQ a0, t2, JOGAR
BEQ a0, t3, SAIR 

	CONFIG:
LI a7,4
LA a0,cfg
ECALL
LA a0, opc
ECALL
LI a7, 5
ECALL

LA t1, var1
LW t1, 0(t1)
LA t2, var2
LW t2, 0(t2)
LA t3, var3
LW t3, 0(t3)
LA t4, var4
LW t4, 0(t4)
LA t5, var5
LW t5, 0(t5)

BEQ a0, t1, CFG_JOGADORES	
BEQ a0, t2, CFG_TABULEIRO
BEQ a0, t3, CFG_DIFICULDADE
BEQ a0, t4, CFG_ZERAR
BEQ a0, t5, CFG_MOSTRAR

	SAIR:
LI a7, 10
ECALL

	CFG_JOGADORES:
LI a7,4
LA a0,cfg_player
ECALL
LI a7, 5
ECALL
mv s0, a0
j INICIO

	CFG_TABULEIRO:
LI a7,4
LA a0,cfg_board
ECALL
LI a7, 5
ECALL
mv s1, a0
j INICIO

	CFG_DIFICULDADE:
LI a7,4
LA a0,cfg_diff
ECALL
LI a7, 5
ECALL
mv s2, a0
j INICIO

	CFG_ZERAR:
LI a7,4
LA a0,cfg_zero
ECALL
mv s3, zero
mv s4, zero
j INICIO

	CFG_MOSTRAR:
LI a7,4
LA a0,cfg_show
ECALL

LI a7,4
LA a0,cfg_show_player
ECALL
mv a0, s0
LI a7, 1
ECALL

LI a7,4
LA a0,cfg_show_board
ECALL
mv a0, s1
LI a7, 1
ECALL
LA a0,xyz6
LI a7, 4
ECALL
LI a7,4
LA a0,cfg_show_diff
ECALL
mv a0, s2
LI a7, 1
ECALL
j INICIO

	JOGAR:
li s5, 1
LA a0, board
MV a1, s1
CALL INICIA_TABULEIRO

	JOGO:
LA a0, board
MV a1, s1
CALL IMPRIME_TABULEIRO
mv a1, s5
la a2, board
CALL RODADA
LA a0, board
mv a1, s1
mv a2, s5
call VERIFICA_VENCEDOR
j JOGO

	INICIA_TABULEIRO:
LI t0, 216
MV t1, a0
li t2, 5
	CLEAR_LOOP:
sb	t2, 0(t1)
ADDI	t1, t1, 1
ADDI    t0, t0, -1
BNEZ    t0, CLEAR_LOOP
RET

	IMPRIME_TABULEIRO:
li t6, 0
li a6, 0
li t1, 7
li t2, 9
BEQ a1, t1, IMPRIME_BOARD7x6
BEQ a1, t2, IMPRIME_BOARD9x6

	IMPRIME_BOARD7x6:
li a1, 7 
li t5, 42 
beq t6, t5, RODADA
addi t6, t6, 1 
li t2, 1
li t3, 2 

lw t1, 0(a0) 
addi a0, a0, 4
addi a6, a6, 1
beq t1, t2, PRINT_P1
beq t1, t3, PRINT_P2
j PRINT_UNDERLINE

	IMPRIME_BOARD9x6:
li a1, 9 
li t5, 54 
beq t6, t5, RODADA 
addi t6, t6, 1 
li t2, 1
li t3, 2 

lw t1, 0(a0) 
addi a0, a0, 4
addi a6, a6, 1
beq t1, t2, PRINT_P1
beq t1, t3, PRINT_P2
j PRINT_UNDERLINE


	PRINT_NEWLINE:
la   a0, newline
li   a7, 4
ecall
li   a6, 0
li t1, 7
li t2, 9
beq s1, t1, IMPRIME_BOARD7x6
beq s1, t2, IMPRIME_BOARD9x6

	PRINT_UNDERLINE:
la   a0, underline
li   a7, 4
ecall
li t1, 7
li t2, 9
beq a6, a1, PRINT_NEWLINE
beq s1, t1, IMPRIME_BOARD7x6
beq s1, t2, IMPRIME_BOARD9x6

	PRINT_P1:
li   a0, 1
li   a7, 1
ecall
li t1, 7
li t2, 9
beq a6, a1, PRINT_NEWLINE
beq s1, t1, IMPRIME_BOARD7x6
beq s1, t2, IMPRIME_BOARD9x6
	PRINT_P2:
li   a0, 2
li   a7, 1
ecall
li t1, 7
li t2, 9
beq a6, a1, PRINT_NEWLINE
beq s1, t1, IMPRIME_BOARD7x6
beq s1, t2, IMPRIME_BOARD9x6











	VERIFICA_VENCEDOR:
mv t1, a0
mv t2, t1
call LADOS



	LADOS:
li t6, 4
beq t3, t6, VENCEDOR 
beq t1, zero, RET_LABEL #tem tabuleiro
lw t0, 0(t2)
beq t0, a2, LADOS_LOOP
#else
addi t1, t1, 4
mv t2, t1
j LADOS

	LADOS_LOOP:
addi t2, t2, 4 
lw t0, 0(t2)
addi t3, t3, 1
j LADOS

	RET_LABEL:
ret

	ALTURA:
li t6, 4
beq t3, t6, VENCEDOR 
beq t1, zero, RET_LABEL #tem tabuleiro
lw t0, 0(t2)
beq t0, a2, ALTURA_LOOP
#else
addi t1, t1, 4
mv t2, t1
j ALTURA

	ALTURA_LOOP:
li a6, 4
mul t5, a1, a6
add t2, t2, t5 
lw t0, 0(t2)
addi t3, t3, 1
j ALTURA

	FECHA:
li a7, 10
ecall

	VENCEDOR:
li a0, 1
mv a1, a2

la a0, msg1
li a7, 4
ecall

mv a0, a1
li a7, 1
ecall

la a0, msg2
li a7, 4
ecall
j INICIO

	RODADA:
la a0, msg3
li a7, 4
ecall
li a7, 5
ecall

j JOGO
