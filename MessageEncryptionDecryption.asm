######### Justin Chen ##########
######### juychen ##########
######### 113097757 ##########

######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########

.text
.globl initialize
initialize:
	move $t0, $a0					# Filename
	move $t1, $a1					# Buffer
	li $v0, 13
	li $a1, 0
	li $a2, 0
	syscall
	
	bltz $v0, errorOpeningFile1
	move $t2, $v0
	
	bltz $v0, errorOpeningFile1
	
	move $a0, $t2
	move $a1, $t1
	li $a2, 1
	
	li $t8, 0
	li $t5, -2							# row counter (down)
	li $t9, 0							# column counter (right)
	li $t7, 1
	initalization:
		li $v0, 14
		syscall
		beqz $v0, exit_initalization
		lbu $t3, 0($a1)
		bltz $v0, errorOpeningFile1
		li $t4, 13						# \r
		beq $t3, $t4, addToColumn				# exit_loopForNumbers
		li $t4, 10						# \n
		beq $t3, $t4, addToRow					# initalization
		li $t4, 32						# space
		beq $t3, $t4, addToColumn				# exit_loopForNumbers
		li $t4, 48
		blt $t3, $t4, errorOpeningFile1
		li $t4, 57
		bgt $t3, $t4, errorOpeningFile1
		addi $t3, $t3, -48
		li $t4, 10		
		mul $t8, $t8, $t4
		add $t8, $t8, $t3
		j initalization
		
	addToColumn:		
		bltz $t5, jumpHere
		sw $t8, 0($a1)
		addi $a1, $a1, 4
		li $t8, 0
		addi $t9, $t9, 1
		j initalization
		jumpHere:
		li $t4, -2
		beq $t4, $t5, insertRowCount
		li $t4, -1
		beq $t4, $t5, insertColumnCount
		insertRowCount:
		move $t0, $t8							# $t0 = row count
		li $t7, 1
		mul $t7, $t0, $t6
		sw $t8, 0($a1)
		addi $a1, $a1, 4
		li $t8, 0
		j initalization
		insertColumnCount:
		move $t6, $t8							# $t6 = column count
		sw $t8, 0($a1)
		addi $a1, $a1, 4
		li $t8, 0
		j initalization
	
	addToRow:
		addi $t5, $t5, 1
		blez $t5, initalization
		beq $t5, $t0, exit_initalization
		bne $t6, $t9, errorOpeningFile1
		li $t9, 0
		j initalization
	
	exit_initalization:
		li $v0, 14
		syscall
		lbu $t3, 0($a1)
		li $t4, 13						# \r
		beq $t3, $t4, successOpeningFile			# exit_loopForNumbers
		li $t4, 10						# \n
		beq $t3, $t4, successOpeningFile			# initalization
		j errorOpeningFile1
		
	successOpeningFile:
	sw $0, 0($a1)
	li $t8, 1
	move $v0, $t8
	li $v0, 16
	move $a0, $t2
	syscall
	jr $ra
	errorOpeningFile1:
	li $t8, -1
	move $v0, $t8
	jr $ra

.globl write_file
write_file:
	li $v0, 13
	move $t0, $a0						# OutFile
	move $t1, $a1
	li $a1, 1
	li $a2, 0
	syscall
	
	bltz $v0, errorOpeningFile2
	
	move $a1, $t1
	move $a0, $t0
	
	li $k1, 0

	move $t5, $v0						# don't use $t5
	
	# row 1
	lw $t3, 0($a1)
	li $t4, 10
	beq $t3, $t4, isTenForRow1
	move $t4, $t3						# $t4 stores the row count
	addi $t3, $t3, 48
	sw $t3, 0($a1)
	move $a0, $t5
	li $v0, 15
	li $a2, 1
	syscall
	addi $k1, $k1, 1
	j addingNewLine1
	
	isTenForRow1:
	li $t3, 49
	sw $t3, 0($a1)
	move $a0, $t5
	li $v0, 15
	li $a2, 1
	syscall
	
	li $t3, 48
	sw $t3, 0($a1)
	move $a0, $t5
	li $v0, 15
	li $a2, 1
	syscall
	
	li $t4, 10						# row count = 10 = $t4
	addi $k1, $k1, 2
	
	addingNewLine1:
	
	li $t3, 10
	sw $t3, 0($a1)
	move $a0, $t5
	li $v0, 15
	li $a2, 1
	syscall
	addi $k1, $k1, 1
	addi $a1, $a1, 4
	
	# row 2
	lw $t3, 0($a1)
	li $t7, 10
	beq $t3, $t7, isTenForRow2
	move $t6, $t3						# $t6 stores the column count
	addi $t3, $t3, 48
	sw $t3, 0($a1)
	move $a0, $t5
	li $v0, 15
	li $a2, 1
	syscall
	addi $k1, $k1, 1
	j addingNewLine2
	
	isTenForRow2:
	li $t3, 49
	sw $t3, 0($a1)
	move $a0, $t5
	li $v0, 15
	li $a2, 1
	syscall
	
	li $t3, 48
	sw $t3, 0($a1)
	move $a0, $t5
	li $v0, 15
	li $a2, 1
	syscall
	
	li $t6, 10						# column count = 10 = $t6
	addi $k1, $k1, 2
	addingNewLine2:
	
	li $t3, 10
	sw $t3, 0($a1)
	move $a0, $t5
	li $v0, 15
	li $a2, 1
	syscall
	addi $k1, $k1, 1
	
	li $t2, 0						# space counter
	mul $k0, $t4, $t6					# row*column
	li $t1, -8

	loopForRemainingRows:
		addi $a1, $a1, 4
		lw $t3, 0($a1)
		beqz, $k0, exit_loopForRemainingRows
		li $t8, 10
		li $t9, 0
		loopForLoadingIntoStack:
			div $t3, $t8
			mflo $t3
			mfhi $t7
			addi $sp, $sp, -4
			sw $t7, 0($sp)
			addi $t9, $t9, 1
			beqz $t3, exit_loopForLoadingIntoStack
			j loopForLoadingIntoStack
		exit_loopForLoadingIntoStack:
		
		loopForLoadingFromStack:
			lw $t7, 0($sp)
			addi $sp, $sp, 4
			addi $t7, $t7, 48
			sw $t7, 0($a1)
			addi $k1, $k1, 1
			move $a0, $t5
			li $v0, 15
			li $a2, 1
			syscall
			addi $t9, $t9, -1
			beqz $t9, exit_loopForLoadingFromStack
			j loopForLoadingFromStack
		exit_loopForLoadingFromStack:
		addi $k0, $k0, -1
		addi $t2, $t2, 1
		beq $t2, $t6, addNextLine
		li $t3, 32
		addi $t1, $t1, -4
		sw $t3, 0($a1)
		addi $k1, $k1, 1
		move $a0, $t5
		li $v0, 15
		li $a2, 1
		syscall
		j loopForRemainingRows
	
		addNextLine:
		li $t3, 13
		addi $t1, $t1, -4
		sw $t3, 0($a1)
		move $a0, $t5
		li $v0, 15
		li $a2, 1
		syscall
		addi $k1, $k1, 1
		li $t2, 0
		j loopForRemainingRows
			
	exit_loopForRemainingRows:
	add $a1, $a1, $t1
	li $v0, 16
	move $a0, $t0
	li $a2, 0
	syscall
	move $v0, $k1
	jr $ra
	
	errorOpeningFile2:
	li $t8, -1
	move $v0, $t8
	jr $ra

.globl rotate_clkws_90
rotate_clkws_90:

	bltz $v0, errorOpeningFile3
													
	lw $t0, 0($a1)				# row counter
	lw $t1, 4($a1)				# column counter
	
	mul $t7, $t0, $t1
	
	sw $t1, 0($a1)
	sw $t0, 4($a1)

	addi $a1, $a1, 8
	move $t3, $t7
	li $t4, 0
	loopToStoreValuesToStack1:
		 lw $t2, 0($a1)
		 sw $t2, 0($sp)
		 addi $sp, $sp, -4
		 addi $a1, $a1, 4
		 addi $t3, $t3, -1
		 addi $t4, $t4, 4
		 beqz $t3, exit_loopToStoreValuesToStack1
		 j loopToStoreValuesToStack1
	exit_loopToStoreValuesToStack1:
		sub $a1, $a1, $t4
		add $sp, $sp, $t4
		
		li $k1, 0
		move $t5, $t0						# row counter
		addi $t5, $t5, -1					# r-1
		li $t8, 4
		mul $t9, $t8, $t1					# (c*4)
		mul $t8, $t9, $t5					# (r-1)(c*4)
		li $k0, 0
		
		sub $sp, $sp, $t8					# $sp - (r-1)(c*4)
		li $t6, 0
		loopForEachColumn1:					
		lw $t2, 0($sp)
		sw $t2, 0($a1)
		addi $k1, $k1, 4
		addi $k0, $k0, 1
		addi $a1, $a1, 4
		beq $k0, $t0, exit_loopForEachColumn1
		add $sp, $sp, $t9
		j loopForEachColumn1
		
		exit_loopForEachColumn1:
		addi $t1, $t1, -1
		beqz $t1, exit_loopToStoreValuesInBuffer1
		addi $sp, $sp, -4
		sub $sp, $sp, $t8
		addi $t6, $t6, 4
		li $k0, 0
		j loopForEachColumn1
		
	exit_loopToStoreValuesInBuffer1:	
	addi $k1, $k1, 8
	sub $a1, $a1, $k1
	add $sp, $sp, $t6
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal write_file
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	errorOpeningFile3:
	li $t8, -1
	move $v0, $t8
	jr $ra
 	
.globl rotate_clkws_180
rotate_clkws_180:

	bltz $v0, errorOpeningFile4
												
	lw $t0, 0($a1)				# row counter
	lw $t1, 4($a1)				# column counter
	mul $t3, $t0, $t1			# row * column
	move $t7, $t3
	addi $a1, $a1, 8
	li $t4, 0
	loopToStoreValuesToStack2:
		 lw $t2, 0($a1)
		 sw $t2, 0($sp)
		 addi $a1, $a1, 4
		 addi $t3, $t3, -1
		 addi $t4, $t4, 4
		 beqz $t3, exit_loopToStoreValuesToStack2
		 addi $sp, $sp, -4
		 j loopToStoreValuesToStack2
	exit_loopToStoreValuesToStack2:
		sub $a1, $a1, $t4
		loopForEachColumn2:
		lw $t2, 0($sp)
		sw $t2, 0($a1)
		addi $a1, $a1, 4
		addi $sp, $sp, 4
		addi $t7, $t7, -1
		beqz $t7, exit_loopToStoreValuesInBuffer2
		j loopForEachColumn2
		
	exit_loopToStoreValuesInBuffer2:
	addi $t4, $t4, 8
	sub $a1, $a1, $t4
	addi $sp, $sp, -4
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal write_file
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	errorOpeningFile4:
	li $t8, -1
	move $v0, $t8
	jr $ra

.globl rotate_clkws_270
rotate_clkws_270:

	bltz $v0, errorOpeningFile5
	
	lw $t0, 0($a1)				# row counter
	lw $t1, 4($a1)				# column counter
	
	mul $t7, $t0, $t1			# row*column
	
	sw $t1, 0($a1)
	sw $t0, 4($a1)

	addi $a1, $a1, 8
	move $t3, $t7
	li $t4, 0
	li $t6, 0
	loopToStoreValuesToStack3:
		 lw $t2, 0($a1)
		 sw $t2, 0($sp)
		 addi $a1, $a1, 4
		 addi $t3, $t3, -1
		 addi $t4, $t4, 4
		 beqz $t3, exit_loopToStoreValuesToStack3
		 addi $sp, $sp, -4
		 j loopToStoreValuesToStack3
	exit_loopToStoreValuesToStack3:
		sub $a1, $a1, $t4
		addi $t4, $t4, -4
		add $sp, $sp, $t4
		
		li $k1, 0
		move $t5, $t1						# column counter
		li $t8, 4
		mul $t7, $t1, $t0
		addi $t7, $t7, -1
		mul $t7, $t7, $t8
		mul $t9, $t8, $t5					# (c*4)
		addi $t5, $t5, -1					# (c-1)
		mul $t8, $t5, $t8					# (c-1)*(4)
		li $k0, 0
		
		sub $sp, $sp, $t8					# $sp - (c-1)*(4)

		loopForEachColumn3:					
		lw $t2, 0($sp)
		sw $t2, 0($a1)
		addi $k1, $k1, 4
		addi $k0, $k0, 1
		addi $a1, $a1, 4
		beq $k0, $t0, exit_loopForEachColumn3
		sub $sp, $sp, $t9
		j loopForEachColumn3
		
		exit_loopForEachColumn3:
		addi $t1, $t1, -1
		beqz $t1, exit_loopToStoreValuesInBuffer3
		add $sp, $sp, $t7
		addi $sp, $sp, 4
		sub $sp, $sp, $t8
		li $k0, 0
		j loopForEachColumn3
		
	exit_loopToStoreValuesInBuffer3:	
	addi $k1, $k1, 8
	sub $a1, $a1, $k1
	li $t6, 0
	addingBackStack3:
		addi $t0, $t0, -1
		beqz $t0, exit_addingBackStack3
		add $t6, $t6, $t9
		j addingBackStack3
	exit_addingBackStack3:
	add $sp, $sp, $t6
	addi $sp, $sp, 4
	sw $ra, 0($sp)
	jal write_file
	lw $ra, 0($sp)
	addi $sp, $sp, -4
	jr $ra
	
	errorOpeningFile5:
	li $t8, -1
	move $v0, $t8
	jr $ra

.globl mirror
mirror:

	bltz $v0, errorOpeningFile6
	
	lw $t0, 0($a1)				# row counter
	lw $t1, 4($a1)				# column counter
	mul $t3, $t0, $t1			# row * column
	move $t7, $t3
	li $t4, 4
	mul $t7, $t7, $t4
	addi $t7, $t7, -4
	addi $a1, $a1, 8
	move $t8, $t1
	li $t4, 0
	li $t6, 0
	loopToStoreValuesToStack4:
		 lw $t2, 0($a1)
		 sw $t2, 0($sp)
		 addi $a1, $a1, 4
		 addi $t8, $t8, -1
		 addi $t4, $t4, -4
		 beqz, $t8, decrementTheBuffer
		 addi $sp, $sp, -4
		 j loopToStoreValuesToStack4
		 
	decrementTheBuffer:
	add $a1, $a1, $t4
	loopForReversingRowInStack:
		addi $t8, $t8, 1
		lw $t2, 0($sp)
		sw $t2, 0($a1)
		addi $t3, $t3, -1
		beq $t1, $t8, restoreTheColumnCount
		addi $sp, $sp, 4
		addi $a1, $a1, 4
		li $t4, 0
		j loopForReversingRowInStack
		
		restoreTheColumnCount:
		move $t8, $t1
		beqz $t3, exit_loopToStoreValuesToStack4
		addi $a1, $a1, 4
		j loopToStoreValuesToStack4
	exit_loopToStoreValuesToStack4:
	addi $t7, $t7, 8
	sub $a1, $a1, $t7
	addi $sp, $sp, 4
	sw $ra, 0($sp)
	jal write_file
	lw $ra, 0($sp)
	addi $sp, $sp, -4
	jr $ra
	
	errorOpeningFile6:
	li $t8, -1
	move $v0, $t8
	jr $ra

.globl duplicate
duplicate:

	bltz $v0, errorOpeningFile7
	
	lw $t0, 0($a1)				# row counter
	lw $t1, 4($a1)				# column counter
	mul $t3, $t0, $t1			# row * column
	move $t7, $t3
	addi $a1, $a1, 8
	move $t8, $t1
	li $t4, 0
	li $k0, 0				# integer representation of the binary
	li $t6, 0
	loopToStoreValuesToStack5:
		 lw $t2, 0($a1)
		 sll $k0, $k0, 1
		 add $k0, $k0, $t2
		 addi $a1, $a1, 4
		 addi $t3, $t3, -1
		 addi $t4, $t4, 4
		 addi $t8, $t8, -1
		 beqz $t8, RowIsDone
		 j loopToStoreValuesToStack5
	
		RowIsDone:
		sw $k0, 0($sp)
		beqz $t3, exit_loopToStoreValuesToStack5
		addi $t6, $t6, 4
		addi $sp, $sp, -4
		move $t8, $t1
		li $k0, 0
		j loopToStoreValuesToStack5
	exit_loopToStoreValuesToStack5:
		addi $t4, $t4, 8
		sub $a1, $a1, $t4
		
		li $t9, 4
		mul $t5, $t0, $t9					# $sp to reverse the pointer (row)*4 - 8
		addi $t5, $t5, -4
		
		move $t8, $t0						# row
		move $t9, $t0						
		addi $t9, $t9 -1					# row -1
		mul $t8, $t8, $t9					# (row -1)*row
		li $t9, 2
		div $t8, $t9
		mflo $t7						# row(row-1)/2
		
		li $t9, 0						# stores the index of the duplicate
		addi $t9, $t1, 1					# stores number of columnns + 1
		move $t3, $t9
		move $t1, $t0						# stores row number
		
		li $k0, 0
		
		li $t4, 0						# outerloop incrementer
		outerLoop:
		beq $t4, $t1, exit_outerLoop
		add $sp, $sp, $t6
		lw $t2, 0($sp)						# stores current number
		li $t1, 0
		addi $t0, $t0, -1
			innerLoop:
			beq $t0, $t1, finishedRowComparison
			addi $sp, $sp, -4
			lw $t8, 0($sp)					# stores comparing number
			addi $t1, $t1, 1
			beq $t8, $t2, foundDuplicate
			addi $t7, $t7, -1
			j innerLoop
			foundDuplicate:
				blt $t0, $t9 switchValues
				j innerLoop
				switchValues:
				move $t9, $t0
				add $t9, $t9, $k0
				j innerLoop
		finishedRowComparison:
		addi $k0, $k0, 1
		move $t1, $t0
		addi $t6, $t6, -4
		beqz $t7, exit_outerLoop
		j outerLoop
		
		exit_outerLoop:
		add $sp, $sp, $t5
		beq $t9, $t3, noDuplicate
		li $v0, 1
		move $v1, $t9
		jr $ra
		
		noDuplicate:
		li $v0, -1
		li $v1, 0
		jr $ra
		
		errorOpeningFile7:
		li $t8, -1
		move $v0, $t8
		jr $ra
