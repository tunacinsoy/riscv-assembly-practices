#-------------------------------------------------------------------------------
# author       : Tuna Cinsoy
# date         : 2023.03.23
# description  : RISC-V - Reversing the order of digits in a string
#-------------------------------------------------------------------------------
    
	.data
	
input:  .space 80          # Reserve 80 bytes for input
prompt: .asciz "\nInput String: "
output: .asciz "\nOutput String: "

	.text
main:
    # Display prompt
    li a7, 4
    la a0, prompt
    ecall

    # Read input string
    li a7, 8
    la a0, input
    li a1, 80
    ecall

    la t2, input          # Pointer to traverse the string
    li t4, -1             # Initialize t4 (start of digit sequence) to -1 (not set)

process_string:
    lbu t3, 0(t2)         # Load the current character
    beqz t3, finish       # Check for null terminator to end

    # Check if the character is a digit
    li t0, '0'
    li t1, '9'
    blt t3, t0, check_end_digit_sequence
    bgt t3, t1, check_end_digit_sequence

    # If it's a digit and t4 is -1, mark the start of the digit sequence
    bgez t4, continue_search # Skip if t4 is already set
    mv t4, t2              # Mark the start of the digit sequence

    j continue_search

check_end_digit_sequence:
    # If t4 is not -1, we've found the end of a digit sequence
    bltz t4, continue_search # If t4 is -1, we're not in a digit sequence

    # Set t5 to the character before t2 (end of digit sequence)
    addi t5, t2, -1
    j reverse_loop

continue_search:
    addi t2, t2, 1        # Move to the next character
    j process_string

    # Reverse the digit sequence between t4 (start) and t5 (end)
reverse_loop:
    lb a4, 0(t4)
    lb a5, 0(t5)
    sb a5, 0(t4)
    sb a4, 0(t5)
    addi t4, t4, 1        # Increment start index
    addi t5, t5, -1       # Decrement end index
    blt t4, t5, reverse_loop
    
    # Reset t4 and prepare to search for the next digit sequence
    li t4, -1
    j continue_search

finish:
    # Display output
    li a7, 4
    la a0, output
    ecall
    li a7, 4
    la a0, input
    ecall

    # Exit program
    li a7, 10
    ecall
