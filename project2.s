.data
input_str: .space 1001
unrecognized_input: .asciiz "Unrecognized input"

.text
main:


li $v0,10
syscall

convert_string_to_decimal:
##################################################
# input registers used: $a0
# output registers used: 
#       $v0 - whether string is invalid or not
#       $v1 - the convert_string_to_decimal value of string, if valid
###################################################
jr $ra