.data
input_str: .space 1001
unrecognized_input: .asciiz "Unrecognized input"

.text
main:


li $v0,10
syscall

convert_string_to_decimal:

jr $ra