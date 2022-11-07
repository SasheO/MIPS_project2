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
#       $v0 - whether string is invalid or not
#       $v1 - the convert_string_to_decimal value of string, if valid
#       temporary registers used: $t0
#
# should pass test case of no input string, all spaces input string
#
# called by main
# calls none
###################################################

loop:
    lb $t0,0($a0) # load character at this of string into $t0
    beq $t0,$zero,exit_subprogram # when null char is read
    addi $a0,$a0,1 # increment the address in $a0 by one to move onto next character in the next loop

j loop

exit_subprogram:
jr $ra