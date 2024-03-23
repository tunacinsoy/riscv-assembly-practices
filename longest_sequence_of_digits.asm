#-------------------------------------------------------------------------------
# author       : Tuna Cinsoy
# date         : 2023.03.23
# description  : RISC-V - Displaying the longest sequence of digits found in a string
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
	mv a1, a0      # Load address of the string into a1
    	li t0, 0       # Current index
    	li t1, 0       # Current sequence length
    	li t2, 0       # Start index of the current sequence
    	li t3, 0       # Length of the longest sequence
    	li t4, 0       # Start index of the longest sequence
	li t5, '0'     # Load ASCII value of '0' into t5
	li t6, '9'     # Load ASCII value of '9' into t6
	li a3, 1       # Load integer 1 into a3, which will be used for comparison 
			
find_sequence:
	lbu a2, (a1) # a2 contains the current character in the string
	beqz a2, display_output # If the current char is the end of the line char, jump out of the loop
	blt a2, t5, not_digit # If character < '0', jump to not_digit
	bgt a2, t6, not_digit # If character < '0', jump to not_digit
	
	# At this point, we know that a2 register contains a digit character
	addi t1, t1, 1 # Increment current sequence length
	bne t1, a3, continue # If current sequence length is not 1, no need to update the start index of current sequence
	add t2, t0, zero #Set starting index of current seqence
	j continue
	
not_digit:
    	# Compare current sequence length with longest found
    	blt t1, t3, update_index  # If current sequence length is less, go to reset sequence length
    	add t3, t1, zero  # Update the longest sequence length
    	add t4, t2, zero  # Update the start index of the longest sequence
    	j reset
    
update_index:
    	# Reset current sequence length and continue searching
    	li t1, 0  # Reset current sequence length
	
continue:
    	addi a1, a1, 1  # Move to the next character
    	addi t0, t0, 1  # Increment current index
    	j find_sequence

reset:
    	li t1, 0  # Make sure to reset sequence length here too if not jumping to update_index
    	addi a1, a1, 1  # Move to the next character
    	addi t0, t0, 1  # Increment current index
    	j find_sequence
		
	# Displaying output prompt and converted string
display_output:
    	li a7, 4
    	la a0, output
    	ecall

    	la a1, input         # Reset a1 to point to the start of the input string
    	add a1, a1, t4       # Correctly set a1 to point to the start of the longest sequence
    	li t5, 0             # Counter for the length of the sequence we're printing

    	j print_sequence     # Jump to start printing the sequence

print_sequence:
	# TODO - Display the characters which reside in the longest sequence of digits in given string
	bge t5, t3, exit # If the counter which is stored in t5 is greater than t3 which stores the length of the longest sequence, branch to exit
	lbu a0, (a1) # Load the value stored in the memory address pointed by a1 register into a0 register
	
	#Syscall for printing characters
	li a7, 11
	ecall
	
	# Move on to the next character in the string
	addi a1, a1, 1
	addi t5, t5, 1
	j print_sequence
	
exit:
	li a7, 10
	ecall