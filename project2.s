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
#       temporary registers used: $t0,$t1,$t2,$t3
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

j loop

exit_subprogram:
jr $ra