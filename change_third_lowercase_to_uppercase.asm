#------------------------------------------------------------------------------------------------------------------
# author       : Tuna Cinsoy
# date         : 2023.03.24
# description  : RISC-V - Change every 3rd lowercase letter to uppercase: “ab1cde2f3gh4ij” → “ab1Cde2Fgh4Ij”
#------------------------------------------------------------------------------------------------------------------

	.data
	
input:	.space 80
prompt: .asciz "\n Input String: "
output: .asciz "\n Output String: "

	.text
main:
	# Displaying the prompt string
	li a7, 4
	la a0, prompt
	ecall
	
	# Reading the input string
	li a7, 8
	la a0, input
	li a1, 80
	ecall
	
	# String Operations
	la a1, input # a1 will also hold the address of the input string, just like a0
	li t0, 0 # Counter for the lowercase letters found in string
	li t2, 'a'
	li t3, 'z'
	li t4, 3 # will be used for checking if current char is the 3rd lowercase letter
	
loop:
	lbu t1, (a1) # Load current character into t1
	beq t1, zero, display_output # If current char is null terminator, jump out of the loop
	blt t1, t2, not_lowercase # If char < 'a', not a lowercase letter
	bgt t1, t3, not_lowercase # If char > 'z', not a lowercase letter
	
	# At this point, current character is lowercase letter
	addi t0, t0, 1 # increment counter of lowercase letters
	beq t0, t4, third_lowercase # If it is the third lowercase, jump to there
	addi a1, a1, 1 # It is not the third lowercase, so continue searching
	j loop

third_lowercase:
	li t6, 32 # Difference between lowercase and uppercase in ASCII
	sub t1, t1, t6 # Convert that character to uppercase
	sb t1, (a1) # Store it back into its original position

not_lowercase:
	addi a1, a1, 1 # Continue iteration
	j loop

display_output:
	# Displaying the output and modified string
	li a7, 4
	la a0, output
	ecall
	li a7, 4
	la a0, input
	ecall

exit:
	li a7, 10
	ecall
