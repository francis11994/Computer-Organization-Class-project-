# Name: Francis Kim
# File of Name: proj03.s
# Due: 10/06/2016 9:00 pm
# Project 2 : this project was going to require that you implement Bubble Sortover strings.
#	      you will implement string compare (comparable to C�s standard function strcmp())
# 	      between strings that are on an array.
#             Mode1: print error case
#	      Mode2: print strings of array
#	      Mode3: print specific character from s1 and c
#	      Mode4: Swap s1 and s2, and print strings of array swaped


.data

newline: .asciiz "\n"		# this print new line
error: .asciiz "Invalid mode."	# this print error case

.text
main:
	# Prologue: set up stack and frame pointers for main
    	addiu   $sp, $sp, -24    # allocate stack space -- default of 24 here
      	sw      $fp, 0($sp)      # save caller's frame pointer
     	sw      $ra, 4($sp)      # save return address
      	addi    $fp, $sp, 20     # setup main's frame pointer

	#Start Program
	la $t0, mode
	lb $s0, 0($t0)		# $s0 = mode

	slti $t0, $s0, 2	# if $s0 < 2
	beq $t0, $zero, ModeTwo	# false, check Mode 2

	# print error
	la $a0, error		# print "Invalid Mode"
	addi $v0, $zero, 4
	syscall

	# print newline
	la $a0, newline
	addi $v0, $zero, 4
	syscall
	j loopEnd

ModeTwo:
	slti $t0, $s0, 3	# if $s0 < 3
	beq $t0, $zero, ModeThree	# false, check Mode 3
	j PrintString		# true, jump to PrintString

ModeThree: 
		slt $t0, $s0, 4 # if $s0 < 4
		beq $t0, $zero, ModeFour #false, check Mode 4
		j DoubleIndex	#true, jump to DoubleIndex

ModeFour:
		# $s0 should be 4
		slt $t0, $s0, 5 # if $s0 < 4
		beq $t0, $zero, errorPrint #false, jump errorPrint
		j strcmp 	# jump to String Compare
errorPrint:
	# print error
	la $a0, error		# print "Invalid Mode"
	addi $v0, $zero, 4
	syscall
	# print newline
	la $a0, newline
	addi $v0, $zero, 4
	syscall
	j loopEnd

PrintString:
	la $t0, numStrs 	# $t0 = address of numStrs
	lb $s0, 0($t0)  	# $s0 = numStrs

	la $t0, strings		# $t0 = address of strings array
	addi $t1, $zero, 0 	# i = 0
	j loopBeginPrintString
			

DoubleIndex:
	la $t0, strings		# $t0 = address of strings array
	addi $t1, $zero, 0 	# i = 0

	la $t2, s1
	lb $s1, 0($t2)		# $s1 = s1
	addi $s1, $s1, 1	# $s1 = s1 + 1

	la $t2, c
	lh $s2, 0($t2)		# $s2 = c

	j loopBeginPrintDoubleIndex

loopBeginPrintString:
	
	slt $t2, $t1, $s0  	# $t2 = i < numStrs
	beq $t2, $zero, loopEnd
	add $t2, $t1, $t1
	add $t2, $t2, $t2  	# $t2 = 4 * i
	add $t3, $t0, $t2  	# $t3 = address of strings[i]

	# print strings of array
	lw $a0, 0($t3)
	addi $v0, $zero, 4
	syscall

	# print newline
	la $a0, newline
	addi $v0, $zero, 4
	syscall

	addi $t1, $t1, 1 	# i++
	j loopBeginPrintString

loopBeginPrintDoubleIndex:

	slt $t3, $t1, $s1 	# i < s1+1
	beq $t3, $zero, searchCharacter # false, jump to search Character
	add $t3, $t1, $t1
	add $t3, $t3, $t3	# $t3 = 4 * i
	add $t5, $t0, $t3	# $t5 = address of strings[i]

	addi $t1, $t1, 1 	# i++
	j loopBeginPrintDoubleIndex

searchCharacter:

	lw $s4, 0($t5)		# $s4 = $t5 = address of strings[i]
 	la $t5, ($s4)		# $t5 = address of $s4

	addi $t1, $zero, 0 	# i=0
	j loopBeginSearchCharacter

loopBeginSearchCharacter:
	
	add $s4, $t5, $t1	# $t2 = address of strings[s1] + i
	
	slt $t3, $t1, $s2 	# i < c
	beq $t3, $zero, printCharacter	# if i=c, then jump printCharacter
	
	addi $t1, $t1, 1 	# i++
	j loopBeginSearchCharacter

printCharacter:

	# print STR_CONST
	lb $a0, 0($s4)		# print specific character
	addi $v0, $zero, 11
	syscall

	# print newline
	la $a0, newline
	addi $v0, $zero, 4
	syscall

	j loopEnd		# loop end

strcmp:
	la $t0, s1
	lb $t1, 0($t0)		# $t1 = s1
	addi $t1, $t1, 1	# $t1 = s1+1

	la $t0, s2
	lb $t2, 0($t0)		# $t2 = s2
	addi $t2, $t2, 1	# $t2 = s2 + 1

	addi $t3, $zero, 0	# i=0

	la $s1, strings		# $s1 = address of strings

	j loopBeginFindS1

loopBeginFindS1:

	slt $t0, $t3, $t1	# i < s1 + 1
	beq $t0, $zero, setUpStringS1
	add $t0, $t3, $t3
	add $t0, $t0, $t0
	add $t4, $s1, $t0	# $t4 = address of strings[i]

	addi $t3, $t3, 1 	# i++
	j loopBeginFindS1

	
setUpStringS1:

	lw $s2, 0($t4)		# $s2 = strings[s1]
	addi $t3, $zero, 0
	j loopBeginFindS2

loopBeginFindS2:
	
	slt $t0, $t3, $t2	# i < s2 + 1
	beq $t0, $zero, setUpStringS2
	add $t0, $t3, $t3
	add $t0, $t0, $t0
	add $t5, $s1, $t0	# $t4 = address of strings[i]

	addi $t3, $t3, 1 	# i++
	j loopBeginFindS2

setUpStringS2:
	lw $s3, 0($t5)		# $s3 = strings[s2]
	addi $t3, $zero, 0
	j swap

swap:
	
	la $t0, ($t4)
	sw $s3, 0($t0)		# swap s1 to s2

	la $t0, ($t5)
	sw $s2, 0($t0)
	j PrintStringSwap	# swap s2 to s1

PrintStringSwap:
	la $t0, numStrs 	# $t0 = address of numStrs
	lb $s0, 0($t0)  	# $s0 = numStrs

	la $t0, strings		# $t0 = address of strings array
	addi $t1, $zero, 0 	# i = 0
	j loopBeginPrintString	# jump to print swaped array (jump to Mode2)

loopEnd:

done:    # Epilogue for main -- restore stack & frame pointers and return
         lw    $ra, 4($sp)    # get return address from stack
         lw    $fp, 0($sp)    # restore the caller's frame pointer
         addiu $sp, $sp, 24   # restore the caller's stack pointer
         jr    $ra            # return to caller's code
