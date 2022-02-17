.data
buffer:
.space 16

matrix:
# table
.align 4
.word 35:9

AN:
.asciiz	"  ABC"

winX:
.asciiz "\nX WIN"

linefeed:
.asciiz "\n"


.text
.globl main
main:
li $t1, 0
li $t2, 0
li $s2, 3					# line feed
li $s3, 1					# player


printAN:
la $a0, AN
li $v0, 4
syscall

printTable:
lw $t0, matrix($t1)

		beq $t1, 36, isEndGame

		div $t1, $s2
		mfhi $t3

		beq $t3, $zero, printLF
		jal printM

		printLF:
		add $t2, $t2, 1

		la $a0, linefeed
		li $v0, 4
		syscall

		move $a0, $t2
		li $v0, 1
		syscall

		li $a0, ' '
		li $v0, 11
		syscall

		printM:
		move $a0, $t0
		li $v0, 11
		syscall

		add $t1, $t1, 4

		j printTable

		isEndGame:
		li $t1, 0
		li $t2, 0
		li $t5, 0
		li $t6, 0
lw $t0, matrix($t1)

		beq $t0, 79, checkLine			# check X

		checkLine:
# check line X
		li $t0, 0
		li $t3, 8
		slt $t4, $t1, $t3
		beq $t4, 1, checkALine

		jal getMove

		checkALine:
		beq $t0, 79, checkA1Collum
		beq $t0, 35, checkA1Collum

		beq $t2, 12, winA

lw $t0, matrix($t2)

		add $t2, $t2, 4

		j checkALine

		checkA1Collum:
		beq $t6, 79, breakLoop
		beq $t6, 35, breakLoop

		beq $t5, 36, winA

lw $t6, matrix($t5)

		add $t5, $t5, 12

		j checkA1Collum


		winA:
		la $a0, winX
		li $v0, 4
		syscall
		jal exit

		breakLoop:
		add $t1, $t1, 4


		getMove:
		la $a0, linefeed
		li $v0, 4
		syscall

		li $v0, 8		# read user move

		la $a0, buffer	# load byte space
		li $a1, 16		# allot byte space

		move $t0, $a0	# save move
		syscall

		getAN:
		lb $s0, ($t0)	# get letter

		add $t0, $t0, 1

		lb $s1, ($t0)	# get number

		beq $s0, 97, A
		beq $s0, 98, B
		beq $s0, 99, C

		A:
		li $s0, 0
		jal breakGetAN
		B:
		li $s0, 1
		jal breakGetAN
		C:
		li $s0, 2

		breakGetAN:
		sub $s1, $s1, 48

		setAN:
		beq $s1, 2, Two
		beq $s1, 3, Three
		jal One

		Two:
		add $s0, $s0, 3
		jal One
		Three:
		add $s0, $s0, 6
		One:

		mul $s0, $s0, 4

		beq $s3, 1, X
		jal O

		X:
		li $s3, 0
		li $t2, 88
		jal breakSetAN

		O:
		li $s3, 1
		li $t2, 79

		breakSetAN:
sw $t2, matrix($s0)

		li $t1, 0
		li $t2, 0

		jal printAN

		exit:
# end program
		li $v0, 10
		syscall
