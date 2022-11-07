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

li $v0,10
syscall

convert_string_to_decimal:
##################################################
# input registers used: $a0
# output registers used: 
#       $v0 - whether string is invalid (0) or not (non-zero)
#       $v1 - the convert_string_to_decimal value of string, if valid
#       temporary registers used: $t0,$t1,$t2,$t3,$t4
#
#
# called by main
# calls none
###################################################

li $t1,32 # holds space char
li $v0,0 # initialized to invalid
li $v1,0 # initialized to 0 - running sum
li $t2,0 # will hold how many valid characters found
li $t3,0 # will hold 1 if spaces found after first non-space char

loop:
    lb $t0,0($a0) # load character at this of string into $t0
    beq $t0,$zero,exit_subprogram # when null char is read
    addi $a0,$a0,1 # increment the address in $a0 by one to move onto next character in the next loop

    check_0_to_9:
        addi $t2,$t2,1 # increment number of valid characters found
        slti $t4,$t0,48 # the string char in $t1 should be greater than or equal to '0' char i.e. $t4 should be 0
        bne $t4,$zero,check_a_to_p # if $t4 not 0, do the next check
        slti $t4,$t0,58 # check if character <= ascii code for 9 # the string char in $t0 should be less than or equal to '9' char i.e. $t0 should be 1
        beq $t4,$zero,check_a_to_p # if $t0 0 instead of 1, do the next check
    
        addi $t0,$t0,-48 # convert ascii value to integer (0-9 ascii: 48-57)
        j add_to_running_sum # j to segment of loop that adds char value to value of $v1, the running sum


    check_a_to_p:
        addi $t2,$t2,1 # increment number of valid characters found
        slti $t4,$t0,97 # the string char in $t1 should be greater than or equal to 'a' char i.e. $t0 should be 0
        bne $t4,$zero,check_A_to_P # if $t4 not 0, do the next check
        slti $t4,$t0,$113 # check if character <= ascii code for 'p' # the string char in $t0 should be less than or equal to 'p' char i.e. $t4 should be 1
        beq $t4,$zero,check_A_to_P # if $t4 0 instead of 1, do the next check

        addi $t0,$t0,-87 # convert ascii value to integer (a-p ascii: 97-112; a-p here: 10-25)
        j add_to_running_sum # j to segment of loop that adds char value to value of $v1, the running sum

    check_A_to_P:
        addi $t2,$t2,1 # increment number of valid characters found
        slti $t4,$t0,65 # the string char in $t1 should be greater than or equal to 'A' char i.e. $t4 should be 0
        bne $t4,$zero,check_space_char # if $t4 not 0, do the next check
        slti $t4,$t0,$81 # check if character <= ascii code for 'P' # the string char in $t0 should be less than or equal to 'p' char i.e. $t4 should be 1
        beq $t4,$zero,check_space_char # if $t4 0 instead of 1, do the next check

        addi $t0,$t0,-55 # convert ascii value to integer (A-P ascii: 65-80; A-P here: 10-25)
        j add_to_running_sum # j to segment of loop that adds char value to value of $v1, the running sum
    
    check_space_char:
        # if first valid char has been found, update $t3 to 1
        # else, do nothing. (j loop)
        bne $t2,$zero,update_t3_to_one
        j loop

        update_t3_to_one:
            addi $t3,$t3,1
            j loop



add_to_running_sum:
    addu $v1,$v1,$t0
    j loop

exit_subprogram:
jr $ra