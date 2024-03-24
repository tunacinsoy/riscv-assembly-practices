#--------------------------------------------------------------------------------------------------------------------------
# author       : Tuna Cinsoy
# date         : 2023.03.24
# description  : RISC-V - Remove all letters but the first from each sequence of uppercase letters: “ABCdefGHi” -> AdefGi”
#--------------------------------------------------------------------------------------------------------------------------

	.data
	
input:	.space 80
output: .space 80
prompt: .asciz "\n Input String: "
result: .asciz "\n Output String: "

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
	la a1, output
	li t1, 2 # t1 is state flag, 2 means we are not in an uppercase sequence
	li t3, 'A' # Loading the ASCII value of 'A' for comparison
	li t4, 'Z' # Loading the ASCII value of 'Z' for comparison
	li t5, 2 # Will be used in comparison
loop:
	lb t2, (a0) # t2 has the current character in string
	beqz t2, display_output # If current character is null terminator, jump out of the loop
	# Check if current character is uppercase
	blt t2, t3, lowercase
	bgt t2, t4, lowercase
	
	#At this point, we are sure that current char is uppercase character
	beq t1, t5, first_uppercase # If flag is 2, this is the first uppercase letter in sequence
	# If we are in the middle of uppercase sequence (t1 = 1), skip this character
	j increment_input
	
first_uppercase:
	li t1, 1 # We are in uppercase sequence
	j copy_char # Copy the first uppercase character to output string	
	
lowercase:
	li t1, 2 # Load 2 into t1 flag, we are not in an uppercase sequence
	j copy_char
	
copy_char:
	sb t2, (a1) # Storing the character in t2 to the memory address which is pointed by a1
	addi a1, a1, 1 # Incrementing a1 pointer by 1

increment_input:
	addi a0, a0, 1 # Increment pointer by 1 to continue iteration on input string
	j loop

display_output:
	
	sb zero, (a1) # Null terminating the output string
	
	# Displaying the output and modified string
	li a7, 4
	la a0, result
	ecall
	li a7, 4
	la a0, output
	ecall

exit:
	li a7, 10
	ecall
