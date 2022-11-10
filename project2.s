.data
input_str: .space 1001
unrecognized_input: .asciiz "Unrecognized input"

.text
main:

li $v0,8 # read string
la $a0,input_str
li $a1,1001
syscall 

jal convert_string_to_decimal

addu $t0,$v0,$zero
beq $t0,$zero,print_unrecognized_input
j print_decimal_char

print_unrecognized_input:
    li $v0,4
    la $a0,unrecognized_input
    syscall
    j exit_program

print_decimal_char: # for valid inputs, print no of valid chars (stored in stack), comma (ascii 44), then decimal value (stored in $v1 from exit_subprogram)

    addi $sp,$sp,-4
    lw $a0,0($sp)
    li $v0,1 # print integer
    addi $sp,$sp,4
    syscall # print number of valid characters stored in stack

    li $v0, 11
    li $a0, 44
    syscall # print comma

    li $v0,1
    addu $a0,$v1,$zero
    syscall

exit_program:
    li $v0,10
    syscall

convert_string_to_decimal:
##################################################
# input registers used: $a0
# output registers used: 
#       $v0 - whether string is invalid (0) or not (non-zero)
#       $v1 - the convert_string_to_decimal value of string, if valid
#       output stack: 1 word for storing no of valid chars
#       temporary regesters used: $t0,$t1,$t2,$t3,$t4,$t5,$t6,$t7
#
#
# called by main
# calls none
###################################################

li $v0,0 # initialized to invalid
li $v1,0 # initialized to 0 - running sum
li $t2,0 # will hold how many valid characters found
li $t3,0 # will hold 1 if spaces found after first non-space char
li $t6,10 # will hold enter character
li $t7,26 # will hold the value of base 26 to multiply base-26 numbers by for the sum

loop:
    lb $t0,0($a0) # load character at this of string into $t0
    beq $t0,$zero,exit_subprogram # when null char is read
    beq $t0,$t6,exit_subprogram # when enter char is read in case less than 1000 chars read and the user clicks enter
    addi $a0,$a0,1 # increment the address in $a0 by one to move onto next character in the next loop

    check_0_to_9:
        slti $t4,$t0,48 # the string char in $t0 should be greater than or equal to '0' char i.e. $t4 should be 0
        bne $t4,$zero,check_a_to_p # if $t4 not 0, do the next check
        slti $t4,$t0,58 # check if character <= ascii code for 9 # the string char in $t0 should be less than or equal to '9' char i.e. $t0 should be 1
        beq $t4,$zero,check_a_to_p # if $t0 0 instead of 1, do the next check
    
        addi $t0,$t0,-48 # convert ascii value to integer (0-9 ascii: 48-57)
        j add_to_running_sum # j to segment of loop that adds char value to value of $v1, the running sum


    check_a_to_p:
        slti $t4,$t0,97 # the string char in $t0 should be greater than or equal to 'a' char i.e. $t0 should be 0
        bne $t4,$zero,check_A_to_P # if $t4 not 0, do the next check
        slti $t4,$t0,113 # check if character <= ascii code for 'p' # the string char in $t0 should be less than or equal to 'p' char i.e. $t4 should be 1
        beq $t4,$zero,check_A_to_P # if $t4 0 instead of 1, do the next check

        addi $t0,$t0,-87 # convert ascii value to integer (a-p ascii: 97-112; a-p here: 10-25)
        j add_to_running_sum # j to segment of loop that adds char value to value of $v1, the running sum

    check_A_to_P:
        slti $t4,$t0,65 # the string char in $t0 should be greater than or equal to 'A' char i.e. $t4 should be 0
        bne $t4,$zero,for_non_valid_inputs # if $t4 not 0, do the next check
        slti $t4,$t0,81 # check if character <= ascii code for 'P' # the string char in $t0 should be less than or equal to 'p' char i.e. $t4 should be 1
        beq $t4,$zero,for_non_valid_inputs # if $t4 0 instead of 1, do the next check

        addi $t0,$t0,-55 # convert ascii value to integer (A-P ascii: 65-80; A-P here: 10-25)
        j add_to_running_sum # j to segment of loop that adds char value to value of $v1, the running sum

    for_non_valid_inputs:
        # TODO: check if space char, if not it is invalid. branch to for_non_valid_inputs
        li $t1,32 # holds space char ascii value
        beq $t0,$t1,update_t3_to_one # if current char is space, update $t3
        li $t1,9 # holds tab char ascii value
        beq $t0,$t1,update_t3_to_one # if current char is space, update $t3

        # any other character is invalid
        li $v0,0
        jr $ra
        
        update_t3_to_one:
            beq $v0,$zero,loop # if no valid chars have been found i.e. space/tab is leading sandwiched between valid chars, loop again
            addi $t3,$t3,1 # if space/tab is after valid character, update t3
            j loop

# TODO: convert to base n, do not just add the value of char
add_to_running_sum:
    bne $t3,0,for_non_valid_inputs # if spaces/tabs are sandwiched between chars, it is a non-valid input
    li $v0,1 # valid chars have been found
    addi $t2,$t2,1 # increment number of valid characters found
    # check if too many valid chars found (5+)
    li $t5,5
    beq $t2,$t5,for_non_valid_inputs
    mul $v1,$v1,$t7 # multiple previous sum by power of 26
    addu $v1,$v1,$t0 # add current valid digit
    j loop

exit_subprogram:
# push $t2 (no of valid chars found) to stack
addi $sp,$sp,-4
sw $t2,0($sp)
addi $sp,$sp,4
jr $ra