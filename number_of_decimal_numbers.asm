#------------------------------------------------------------------------------------------------------------------
# author       : Tuna Cinsoy
# date         : 2023.03.24
# description  : RISC-V - Displaying the number of decimal numbers (sequences of decimal digits) found in a string.
#------------------------------------------------------------------------------------------------------------------

	.data
	
input:	.space 80
prompt: .asciz "\n Input String: "
output: .asciz "\n Number of Decimal Numbers: "

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
	li t0, 0 # Count of decimal numbers found in given string
	li t1, 0 # Check flag if the current char is part of a number
	li t3, '0' # Loading ASCII value of '0' into t3
	li t4, '9' # Loading ASCII value of '9' into t4
	
check_next_char:
	lbu t2, (a0) # Load current character into t2
	beq t2, zero, end_of_string # If the current char is null terminator, get out of the loop
	blt t2, t3, not_a_digit # If char's ascii value is less than '0'
	bgt t2, t4, not_a_digit # If char's ascii value is greater than '9'
	# At this point, we are sure that current char is digit
	li t1, 1 # We need to set the flag to 1, since we are in number at the moment
	j check_next_char_increment
	
not_a_digit:
	# If t1 is 1, we finished a digit sequence. We need to increment t0 and reset t1.
	bnez t1, increment_count
	j check_next_char_increment

increment_count:
	addi t0, t0, 1 # Increment count of numbers
	li t1, 0 # Resetting flag
	
check_next_char_increment:
	addi a0, a0, 1 # Moving to the next character in string
	j check_next_char # Jump back to the start of the loop
			
end_of_string:
	# If the string ends with a number (meaning t1 is still 1), we need to increment count
	# before displaying the output
	bnez t1, increment_count  
	j display_output
	
display_output:
	# Displaying the output and modified string
	li a7, 4
	la a0, output
	ecall
	li a7, 1
	mv a0, t0
	ecall

exit:
	li a7, 10
	ecall
