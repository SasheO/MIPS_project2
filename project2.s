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
li $v1,0 # initialized to 0
li $t2,0 # will hold 1 if first non-space char found
li $t3,0 # will hold 1 if spaces found after first non-space char

loop:
    lb $t0,0($a0) # load character at this of string into $t0
    beq $t0,$zero,exit_subprogram # when null char is read
    addi $a0,$a0,1 # increment the address in $a0 by one to move onto next character in the next loop

    check_0_to_9:
        li $t2,1 # first non-space char found
        slti $t4,$t0,48 # the string char in $t1 should be greater than or equal to '0' char i.e. $t4 should be 0
        bne $t4,$zero,check_a_to_p # if $t4 not 0, do the next check
        slti $t4,$t0,58 # check if character <= ascii code for 9 # the string char in $t1 should be less than or equal to '9' char i.e. $t0 should be 1
        beq $t4,$zero,check_a_to_p # if $t0 0 instead of 1, do the next check
    
        addi $t0,$t0,-48 # convert ascii value to integer (0-9 ascii: 48-57)
        j add_to_running_sum # j to segment of loop that adds char value to value of $t9, the running sum

j loop

add_to_running_sum:


exit_subprogram:
jr $ra