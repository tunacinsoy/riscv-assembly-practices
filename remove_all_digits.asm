#------------------------------------------------------------------------------------------------------------------
# author       : Tuna Cinsoy
# date         : 2023.03.24
# description  : RISC-V - Removing all digits from a string, and displaying the resulting string
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
	la t0, input # t0 will be used as destination pointer, we'll replace the char pointed by t0 with the current char in loop
	li t2, '0' # ASCII value of 0
	li t3, '9' # ASCII value of 9
	
remove_digits:
	lbu t1, (a0) # Load current character into t1
	beq t1, zero, display_output # If current char is null terminator, end loop
	blt t1, t2, copy_char # If char < '0'
	bgt t1, t3, copy_char # If char > '9'
	# At this point, current char is a digit 100%
	j skip_char
	

copy_char: 
	# t1 holds non-digit char, t0 is the destination pointer in the same string
	sb t1, (t0) # Store the char in t1 into the address pointed by t0
	addi t0, t0, 1 # Increment destination pointer

skip_char:
	addi a0, a0, 1 # Incrementing source pointer to continue iteration
	j remove_digits

display_output:
	
	sb zero, (t0) # We need to terminate the modified string
	
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
