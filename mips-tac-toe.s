.data
buffer:
.space 16

matrix:
.align 4
.word 35:9

AN:
.asciiz	"  ABC"

winX:
.asciiz "\nX WIN"

winO:
.asciiz "\nO WIN"
errorstr:
.asciiz "invalid movement"
linefeed:
.asciiz "\n"


.text
.globl main
main:
li $t1, 0
li $t2, 3
li $s2, 3						# if mod of 3 print line feed
li $s3, 1						# player


printAN:						# print AN letters
la $a0, AN
li $v0, 4
syscall

		printTable:						# print table
lw $t0, matrix($t1)

		beq $t1, 36, line1X

		div $t1, $s2
		mfhi $t3

		beq $t3, $zero, printLF
		jal printM

		printLF:

		la $a0, linefeed
		li $v0, 4
		syscall

		move $a0, $t2			# print AN number
		li $v0, 1
		syscall
		sub $t2, $t2, 1

		li $a0, ' '
		li $v0, 11
		syscall

		printM:
		move $a0, $t0
		li $v0, 11
		syscall

		add $t1, $t1, 4

		j printTable

		line1X:					# check if X wins in line 1 
		li $t0, 0				# matrix value
		li $t2, 0				# matrix init value

		checkLine1X:			# check line 1 loop
		beq $t0, 79, line2X		# if matrix[index] == O, check next line
		beq $t0, 35, line2X		# if matrix[index] == #, check next line
		beq $t2, 12, winXPlayer # if index == next line value, X wins 

		lw $t0, matrix($t2)				# get matrix value

		add $t2, $t2, 4			# increment matrix

		j checkLine1X			# loop

		line2X:					# check if X wins in line 2
		li $t0, 0				# matrix value 
		li $t2, 12				# matrix init value

		checkLine2X:			# check line 2 loop
		beq $t0, 79, line3X		# if matrix[index] == O, check next line
		beq $t0, 35, line3X		# if matrix[index] == #, check next line
		beq $t2, 24, winXPlayer	# if index == next line value, X wins 

		lw $t0, matrix($t2)				# get matrix value

		add $t2, $t2, 4			# increment matrix

		j checkLine2X			# loop

		line3X:					# check if X wins in line 3
		li $t0, 0				# matrix value
		li $t2, 24				# matrix init value

		checkLine3X:			# check line 3 loop
		beq $t0, 79, line1O		# if matrix[index] == 0, check next line
		beq $t0, 35, line1O		# if matrix[index] == #, check next line
		beq $t2, 36, winXPlayer	# if index == next line valuie, X wins

		lw $t0, matrix($t2)				# get matrix value

		add $t2, $t2, 4			# increment matrix

		j checkLine3X			# loop

		line1O:					# check if O wins in line 1
		li $t0, 0				# matrix value
		li $t2, 0				# matrix init index

		checkLine1O:			# check line 1 loop
		beq $t0, 88, line2O		# if matrix[index] == X, check next line
		beq $t0, 35, line2O		# if matrix[index] == #, check next line
		beq $t2, 12, winOPlayer	# if index == next line value, O wins 
		lw $t0, matrix($t2)				# get matrix value
		add $t2, $t2, 4			# increment matrix 

		j checkLine1O			# loop	

		line2O:					# check if O wins in line 2
		li $t0, 0				# matrix value 
		li $t2, 12				# matrix init index

		checkLine2O:			# check line 2 loop
		beq $t0, 88, line3O		# if matrix[index] == X, check next line 	
		beq $t0, 35, line3O		# if matrix[index] == #, check next line
		beq $t2, 24, winOPlayer	# if index == next line value, O wins		

		lw $t0, matrix($t2)				# get matrix value

		add $t2, $t2, 4			# increment matrix

		j checkLine2O			# loop

		line3O:					# check if O wins in line 3
		li $t0, 0				# matrix value 
		li $t2, 24				# matrix init index

		checkLine3O:			# check line 3 loop
		beq $t0, 88, columnAX	# if matrix[index] == X, check columns  
		beq $t0, 35, columnAX	# if matrix[index] == #, check columns  
		beq $t2, 36, winOPlayer	# if index == end line, O wins 

		lw $t0, matrix($t2)				# get matrix value

		add $t2, $t2, 4			# increment matrix

		j checkLine3O			# loop

		columnAX:				# check if X wins in column A
		li $t0, 0				# matrix value
		li $t2, 0				# matrix init index

		checkColumnAX:			# check column A loop
		beq $t0, 79, columnBX	# if matrix[index] == O, check next column
		beq $t0, 35, columnBX	# if matrix[index] == #, check next column
		beq $t2, 36, winXPlayer	# if index == end of column, X wins

		lw $t0, matrix($t2)				# get matrix value

		add $t2, $t2, 12		# increment matrix

		j checkColumnAX			# loop

		columnBX:				# check if X wins in column B
		li $t0, 0				# matrix value
		li $t2, 4				# matrix init index

		checkColumnBX:			# check column B loop
		beq $t0, 79, columnCX	# if matrix[index] == O, check next column
		beq $t0, 35, columnCX	# if matrix[index] == #, check next column
		beq $t2, 36, winXPlayer # if index == end of column, X wins

		lw $t0, matrix($t2)				# get matrix value

		add $t2, $t2, 12		# increment matrix

		j checkColumnBX			# loop

		columnCX:				# check if X wins in column B
		li $t0, 0				# matrix value
		li $t2, 8				# matrix init index

		checkColumnCX:			# check column B loop
		beq $t0, 79, columnAO	# if matrix[index] == O, check next column
		beq $t0, 35, columnAO	# if matrix[index] == #, check next column
		beq $t2, 44, winXPlayer # if index == end of column, X wins

		lw $t0, matrix($t2)				# get matrix value

		add $t2, $t2, 12		# increment matrix

		j checkColumnCX			# loop


		columnAO:				# check if X wins in column A
		li $t0, 0				# matrix value
		li $t2, 0				# matrix init index

		checkColumnAO:			# check column A loop
		beq $t0, 88, columnBO	# if matrix[index] == X, check next column
		beq $t0, 35, columnBO	# if matrix[index] == #, check next column
		beq $t2, 36, winOPlayer	# if index == end of column, O wins

		lw $t0, matrix($t2)				# get matrix value

		add $t2, $t2, 12		# increment matrix

		j checkColumnAO			# loop

		columnBO:				# check if X wins in column B
		li $t0, 0				# matrix value
		li $t2, 4				# matrix init index

		checkColumnBO:			# check column B loop
		beq $t0, 88, columnCO	# if matrix[index] == X, check next column
		beq $t0, 35, columnCO	# if matrix[index] == #, check next column
		beq $t2, 36, winOPlayer # if index == end of column, O wins

		lw $t0, matrix($t2)				# get matrix value

		add $t2, $t2, 12		# increment matrix

		j checkColumnBO			# loop

		columnCO:				# check if X wins in column B
		li $t0, 0				# matrix value
		li $t2, 8				# matrix init index

		checkColumnCO:			# check column C loop
		beq $t0, 88, diagAX		# if matrix[index] == X, check next column
		beq $t0, 35, diagAX		# if matrix[index] == #, check next column
		beq $t2, 44, winOPlayer # if index == end of column, O wins

		lw $t0, matrix($t2)				# get matrix value

		add $t2, $t2, 12		# increment matrix

		j checkColumnCO			# loop

		diagAX:					# check if X wins in diagonal A1 to C3
		li $t0, 0				# matrix value
		li $t2, 0				# matrix init index

		checkDiagAX:			# check diagonal A1 to C3 loop
		beq $t0, 79, diagCX		# if matrix[index] == O, check next column
		beq $t0, 35, diagCX		# if matrix[index] == #, check next column
		beq $t2, 48, winXPlayer # if index == end of diagonal, X wins

		lw $t0, matrix($t2)				# get matrix value

		add $t2, $t2, 16		# increment matrix

		j checkDiagAX			# loop

		diagCX:					# check if X wins in diagonal C1 to A3
		li $t0, 0				# matrix value
		li $t2, 8				# matrix init index

		checkDiagCX:			# check diagonal C1 to A3 loop
		beq $t0, 79, diagAO		# if matrix[index] == O, check next column
		beq $t0, 35, diagAO		# if matrix[index] == #, check next column
		beq $t2, 32, winXPlayer # if index == end of diagonal, X wins

		lw $t0, matrix($t2)				# get matrix value

		add $t2, $t2, 8			# increment matrix

		j checkDiagCX			# loop

		diagAO:					# check if O wins in diagonal A1 to C3
		li $t0, 0				# matrix value
		li $t2, 0				# matrix init index

		checkDiagAO:			# check diagonal A1 to C3 loop
		beq $t0, 88, diagCO		# if matrix[index] == X, check next column
		beq $t0, 35, diagCO		# if matrix[index] == #, check next column
		beq $t2, 48, winOPlayer # if index == end of diagonal, O wins

		lw $t0, matrix($t2)				# get matrix value

		add $t2, $t2, 16		# increment matrix

		j checkDiagAO			# loop

		diagCO:					# check if O wins in diagonal C1 to A3
		li $t0, 0				# matrix value
		li $t2, 8				# matrix init index

		checkDiagCO:			# check diagonal C1 to A3 loop
		beq $t0, 88, getMove	# if matrix[index] == X, check next column
		beq $t0, 35, getMove 	# if matrix[index] == #, check next column
		beq $t2, 32, winOPlayer # if index == end of diagonal, O wins

		lw $t0, matrix($t2)				# get matrix value

		add $t2, $t2, 8			# increment matrix

		j checkDiagCO			# loop

		winXPlayer:				# print X win
		la $a0, winX
		li $v0, 4
		syscall
		jal exit

		winOPlayer:				# print O win
		la $a0, winO
		li $v0, 4
		syscall
		jal exit

		getMove:				# read move
		la $a0, linefeed
		li $v0, 4
		syscall

		li $v0, 8				# read user input

		la $a0, buffer			# load byte space
		li $a1, 16				# allot byte space

		move $t0, $a0			# save move
		syscall

		getAN:					# move to AN
		lb $s0, ($t0)			# get letter

		add $t0, $t0, 1			# increment vector

		lb $s1, ($t0)			# get number

		beq $s0, 97, A			# get values from AN letters
		beq $s0, 98, B
		beq $s0, 99, C

		A:						# AN letter A
		li $s0, 0
		jal breakGetAN
		B:						# AN letter B
		li $s0, 1
		jal breakGetAN
		C:						# AN letter C
		li $s0, 2

		breakGetAN:				
		sub $s1, $s1, 48		# get number of ascii decimal

		setAN:					# AN to matrix index
		beq $s1, 2, Two
		beq $s1, 3, Three
		jal One

		Two:
		add $s0, $s0, 3
		jal Three
		One:
		add $s0, $s0, 6
		Three:

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
		lw $t0, matrix($s0)				# check if move is valid
		beq $t0, 88, error			
		beq $t0, 79, error
		sw $t2, matrix($s0)				# set move

		li $t1, 0
		li $t2, 3				# print AN numbers
		jal printAN

		error:
		la $a0, errorstr
		li $v0, 4
		syscall
		exit:					# exit program
		li $v0, 10
		syscall
