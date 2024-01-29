Solution
.data
prompt_mul1: .asciiz "Multiplicand?: "
prompt_mul2: .asciiz "Multiplier?: "
error_msg1: .asciiz "Invalid multiplicand. Please try again\n"
error_msg2: .asciiz "Invalid multiplier. Please try again\n"
out1_msg: .asciiz "\n "
out2_msg: .asciiz "\nX "
line: .asciiz "\n --------------------------------"
num_string: .space 12 #place to save numerical strings
.text
.globl main
main:
read_mul1:
# Prompt for multiplicand
li $v0, 4 # syscall to print a string
la $a0, prompt_mul1 # load prompt for multiplicand
syscall # print the prompt
# Read first number as a string
li $v0, 8 # syscall number to read string
la $a0, num_string # place to save read string
li $a1,12 # 12 chars maximum
syscall # read the string
#Convert first number to an integer
la $a0, num_string # load pointer to read string
jal convert_to_int # convert string to integer
move $s0, $v0 # save converted number in s0
beq $v1, $0, read_mul2 # if no errors read next number
# if error print an error message
la $a0, error_msg1 # load address of error message
li $v0, 4 # syscall number to print a string
syscall # print error string
j read_mul1 # read multiplicand again
read_mul2:
# Prompt for multiplier
li $v0, 4 # syscall to print a string
la $a0, prompt_mul1 # load prompt for multiplier
syscall # print the prompt
# Read second number as a string
li $v0, 8 # syscall number to read string
la $a0, num_string # place to save read string
li $a1,12 # 12 chars maximum
syscall # read the string
#Convert second number to an integer
la $a0, num_string # load pointer to read string
jal convert_to_int # convert string to integer
move $s1, $v0 # save converted number in s1
beq $v1, $0, print_muls # if no errors, start printing inputs
# if error print an error message
la $a0, error_msg2 # load address of error message
li $v0, 4 # syscall number to print a string
syscall # print error string
j read_mul2 # read multiplier again
print_muls:
# print spaces
la $a0, out1_msg # load address of message
li $v0, 4 # syscall number to print a string
syscall # print string
# print multiplicand
move $a0, $s0 # load multiplicand number
li $a1, 32 # print in 32 bits
jal print_bin # print number as 32 bit binary
# print multiplication X
la $a0, out2_msg # load address of message
li $v0, 4 # syscall number to print a string
syscall # print string
# print multiplier
move $a0, $s1 # load multiplier number
li $a1, 32 # print in 32 bits
jal print_bin # print number as 32 bit binary
# print division line
la $a0, line # load address of error message
li $v0, 4 # syscall number to print a string
syscall # print string
# start Booth's algorithm
# M = S0
# Q = s1
li $s2, 0 # initialize AC = 0
li $s3, 0 # initialize Q-1 = 0
li $s4, 32 # set counter to n=32 bits long
booth_loop:
#print current registers
# print spaces
la $a0, out1_msg # load address of message
li $v0, 4 # syscall number to print a string
syscall # print string
# print upper register AC
move $a0, $s2 # load number
li $a1, 32 # print in 32 bits
jal print_bin # print number as 32 bit binary
# print lower register Q
move $a0, $s1 # load number
li $a1, 32 # print in 32 bits
jal print_bin # print number as 32 bit binary
andi $t0, $s1, 1 # load LSB of multiplier Q
beq $t0, $s3, shift # if Q0 and Q-1 are equal, go to shift
bne $t0, $0, subtract # if Q0 = 1 and Q-1 is 0, subtract
add: # else, Q0 = 0 and Q-1 is 1, add
add $s2, $s2, $s0 # add AC + M
j shift
subtract:
sub $s2, $s2, $s0 # subtract AC - M
shift:
andi $t1, $s2, 1 # get LSB of AC
sra $s2, $s2, 1 # shift AC to the right
srl $s1, $s1,1 # shift Q to the right
move $s3, $t0 # move Q0 to Q-1
sll $t1, $t1, 31 # put bit shifted out of AC in Q
or $s1, $s1, $t1
addi $s4, $s4, -1 # decrement counter
bne $s4, $0, booth_loop # repeat while counter is not zero
# print last result
# print division line
la $a0, line # load address of error message
li $v0, 4 # syscall number to print a string
syscall # print string
# print spaces
la $a0, out1_msg # load address of message
li $v0, 4 # syscall number to print a string
syscall # print string
# print upper register AC
move $a0, $s2 # load number
li $a1, 32 # print in 32 bits
jal print_bin # print number as 32 bit binary
# print lower register Q
move $a0, $s1 # load number
li $a1, 32 # print in 32 bits
jal print_bin # print number as 32 bit binary
#Exit the program
li $v0, 10 # syscall number to exit program
syscall # exit the program
# Function to convert a string to an integer,
# the string pointer must be given in a0,
# returns the result in v0, v1 is 1 if there was an error
convert_to_int:
li $v1, 0 # start without error flag
li $t0, 45 # load sign character
lb $t1, 0($a0) # load first character from string
li $t2, 0 # load 0 to use as flag to indicate if number is positive
bne $t1, $t0, positive # if not a sign, it's positive, start conversion
li $t2, 1 # save 1 to indicate is negative
addi $a0, $a0, 1 # advance to next char in string
positive:
lb $t1, 0($a0) # load character from numeric string
beq $t1, $0, convert_error # if string is empty, return eror
beq $t1, 10, convert_error # if string is empty, return eror
li $v0, 0 # start with converted number in zero
li $t3, 10 # load 10 to make multiplications
convert_loop:
lb $t1, 0($a0) # load character from numeric string
beq $t1, $0, convert_end # if it's the ending null char, terminate conversion
beq $t1, 10, convert_end # if it's the ending null char, terminate conversion
#validate char
slti $t0, $t1, 48 # compare with '0' char, set t0 to 1 if lower than 0
bne $t0, $0, convert_error # if char < '0' is not a valid digit, go to error
li $t4, 57 # load ascii code for '9' char
beq $t1, $t4, valid_digit # if char is '9', it's a valid digit, continue conversion
slt $t0, $t1, $t4 # compare with '9' char, set t0 to 1 if lower than '9'
beq $t0, $0, convert_error # if char > '9' is not a valid digit, go to error
valid_digit:
addi $t1, $t1, -48 # subtract ascii '0' to convert char to integer
mult $v0, $t3 # multiply old conversion by 10
mflo $v0 # load result in v0
add $v0, $v0, $t1 # add digit to conversion
addi $a0, $a0, 1 # advance to next char in string
j convert_loop # repeat to convert next char
convert_error:
li $v1, 1 # set v1 to 1 to indicate error
li $v0, 0 # clear conversion
li $t2, 0 # clear sign
convert_end:
beq $t2, $0, convert_ret # if the number was positive, return it
xori $v0, $v0, -1 # else, it's negative, convert to negative using two's complement, first invert
addi $v0, $v0, 1 # then add 1
convert_ret:
jr $ra # return to caller with conversion in $v0, error in $v1
# Function to print the number given in a0 as a binary number in the number of bits
# given in a1
print_bin:
move $t2, $a0 # save a0 in t2
print_bin_loop:
slti $a0, $t2, 0 # if negative bit is set, put 1 in t0
addi $a0, $a0, 48 # convert bit to ascii adding '0'
li $v0, 11 # syscall number to print a character
syscall # print bit digit
sll $t2, $t2, 1 # move next bit to sign bit
addi $a1, $a1, -1 # decrement number of bits to print
bne $a1, $0, print_bin_loop # repeat while the number is not zero
jr $ra # return to caller
