#------------------------------------------------------------------------------------------------------------------
# author       : Tuna Cinsoy
# date         : 2023.03.26
# description  : RISC-V - Remove every non-digit from a string and return the length of the output string
#------------------------------------------------------------------------------------------------------------------

	.data

input:  .space 80      
prompt: .asciz "\n Input String: "
output: .asciz "\n Output String: "
length: .asciz "\n Return Value: "

	.text
main:
        # Displaying the prompt string
        li a7, 4
        la a0, prompt
        ecall
    
        # Reading the input string
        li a7, 8
        la a0, input # a0 holds the address of the input string
        li a1, 80
        ecall
    
        # t2 is the counter for the length of the output string
        li t2, 0              
    
        # String Operations
        la a1, input          # a1 also holds the addres of the input string, will be used for output destination

string_loop:
        lbu a2, (a0)          # a2 holds the current character in the string
        beqz a2, display_output   # If current char is null terminator, go to display_output
        li t0, '0'             # Load ASCII value of '0' into t0
        li t1, '9'            # Load ASCII value of '9' into t1
        
        # Check if the current char is digit or not, if it is not skip that character
        blt a2, t0, skip_char # If char < '0' 
        bgt a2, t1, skip_char # If char > '9'
        
        #At this point I am sure that current character is a digit
        
        sb a2, (a1)           # Store current char into the destination point pointed by a1 register
        addi a1, a1, 1        # Increment the destination pointer
        addi t2, t2, 1        # Increment the length counter

skip_char:
        addi a0, a0, 1        # Increment the input string pointer
        j string_loop         # Jump back to the start of the loop

display_output:

        # Putting null terminator at the end of the output string
        sb zero, (a1)
    
        # Displaying the output string
        li a7, 4
        la a0, output
        ecall
        li a7, 4
        la a0, input
        ecall
    
        # Displaying the length of the output string
        li a7, 4
        la a0, length
        ecall
        # System call for print_int
        li a7, 1   
        # Move length value to a0           
        mv a0, t2             
        ecall

exit:
        li a7, 10
        ecall
