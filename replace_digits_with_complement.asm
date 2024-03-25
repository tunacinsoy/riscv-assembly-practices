#-------------------------------------------------------------------------------
# author       : Tuna Cinsoy
# date         : 2023.03.23
# description  : RISC-V - Replacing all digits in a string with their complement to 9 (0->9, 1->8, 2->7 etc.) 
#-------------------------------------------------------------------------------

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
	
	# Modifying string
	
	#char *curr_char = input;
	mv t2, a0 # Move the address in a0 to t2, t2 also points to the memory address which includes input string
	
	li t0, '0' # Load ASCII value of '0' into t0
	li t1, '9' # Load ASCII value of '9' into t1
	
# while(*curr_char != '\0') {
 loop:
	lbu t3, (t2) # t3 contains the current character in the string
	beqz t3, display_output # If the current char is the end of the line char, jump out of the loop
	blt t3, t0, not_digit # If character < '0', jump to not_digit
	bgt t3, t1, not_digit # If character > '9', jump to not_digit
	
	# At this point, we know that t3 register contains a digit character
	sub t3, t1, t3 # Subtract the digit from '9', and put the result in t3 register
	addi t3, t3, '0' # Convert back to ASCII by adding ASCII value of '0'
	sb t3, (t2) # Store the updated character back into the string at the current position
	
	#Continue with the next char in the string
	addi t2,t2,1
	j loop
	
not_digit:
	# If the current char is not digit, increment the address by one, continue to loop
	addi t2,t2,1 
	j loop
		
															
# Displaying output prompt and converted string
display_output:
	li a7, 4
	la a0, output
	ecall
	li a7, 4
	la a0, input
	ecall

exit:
	li a7, 10
	ecall
