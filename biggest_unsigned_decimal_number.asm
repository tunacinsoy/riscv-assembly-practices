#-------------------------------------------------------------------------------
# author       : Tuna Cinsoy
# date         : 2023.03.23
# description  : RISC-V - Scanning the biggest unsigned decimal number found in a string and display its value using print_int function
#-------------------------------------------------------------------------------

    .data
input:  .space 80            # Reserve space for the input
prompt: .asciz "\nInput String: "
output: .asciz "\nBiggest Number: "

    .text
main:
    # Display the input prompt
    li a7, 4
    la a0, prompt
    ecall

    # Read the input string
    li a7, 8
    la a0, input
    li a1, 80
    ecall
    
    la t0, input          # Address of the current character in the string
    li t1, 0              # Current number being processed
    li t2, 0              # Largest number found

process_string:
    lbu a1, 0(t0)         # Load byte (character) from string
    beqz a1, display_result # If zero byte (end of string), go to display result

    # Check if character is a digit
    li a2, '0'
    li a3, '9'
    blt a1, a2, not_digit
    bgt a1, a3, not_digit

    # Convert character to integer and accumulate
    sub a1, a1, a2        # Convert ASCII to integer
    li a4, 10
    mul t1, t1, a4        # Multiply current number by 10 (shift left in decimal)
    add t1, t1, a1        # Add current digit to current number

    j check_next_char

not_digit:
    # Not a digit, compare and reset current number
    bgt t1, t2, update_max # If current number > max, update max
    li t1, 0              # Reset current number

check_next_char:
    addi t0, t0, 1        # Move to the next character
    j process_string

update_max:
    mv t2, t1           # Update max number
    j check_next_char

display_result:
    # Display the biggest number
    li a7, 1              # system call for print_int
    mv a0, t2           # Move the biggest number found into a0
    ecall

    # Exit
    li a7, 10             # system call to exit
    ecall
