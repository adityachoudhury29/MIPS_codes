.data
prompt_mul1: .asciiz "Multiplicand?: "
prompt_mul2: .asciiz "Multiplier?: "
error_msg1: .asciiz "Invalid multiplicand. Please try again\n"
error_msg2: .asciiz "Invalid multiplier. Please try again\n"
out1_msg: .asciiz "\n "
out2_msg: .asciiz "\nX "
line: .asciiz "\n"
num_string: .space 12
.text
.globl main
main:
read_mul1:
li $v0, 4 
la $a0, prompt_mul1 
syscall 
li $v0, 8 
la $a0, num_string 
li $a1,12
syscall 
la $a0, num_string
jal convert_to_int 
move $s0, $v0 
beq $v1, $0, read_mul2 
la $a0, error_msg1 
li $v0, 4 
syscall 
j read_mul1 
read_mul2:
li $v0, 4 
la $a0, prompt_mul1 
syscall 
li $v0, 8 
la $a0, num_string
li $a1,12
syscall 
la $a0, num_string
jal convert_to_int
move $s1, $v0 
beq $v1, $0, print_muls 
la $a0, error_msg2 
li $v0, 4 
syscall 
j read_mul2 
print_muls:
la $a0, out1_msg 
li $v0, 4 
syscall 
move $a0, $s0 
li $a1, 32 
jal print_bin
la $a0, out2_msg 
li $v0, 4 
syscall 
move $a0, $s1 
li $a1, 32 
jal print_bin
la $a0, line 
li $v0, 4 
syscall 
li $s2, 0
li $s3, 0
li $s4, 32
booth_loop:
la $a0, out1_msg
li $v0, 4 
syscall 
move $a0, $s2
li $a1, 32 
jal print_bin
move $a0, $s1 
li $a1, 32 
jal print_bin
andi $t0, $s1, 1 
beq $t0, $s3, shift
bne $t0, $0, subtract
add: 
add $s2, $s2, $s0 
j shift
subtract:
sub $s2, $s2, $s0
shift:
andi $t1, $s2, 1 
sra $s2, $s2, 1 
srl $s1, $s1,1 
move $s3, $t0 
sll $t1, $t1, 31 
or $s1, $s1, $t1
addi $s4, $s4, -1
bne $s4, $0, booth_loop 
la $a0, line 
li $v0, 4 
syscall 
la $a0, out1_msg
li $v0, 4
syscall 
move $a0, $s2
li $a1, 32 
jal print_bin
move $a0, $s1
li $a1, 32 
jal print_bin
li $v0, 10 
syscall 
convert_to_int:
li $v1, 0 
li $t0, 45
lb $t1, 0($a0)
li $t2, 0 
bne $t1, $t0, positive
li $t2, 1 
addi $a0, $a0, 1 
positive:
lb $t1, 0($a0) 
beq $t1, $0, convert_error 
beq $t1, 10, convert_error 
li $v0, 0 
li $t3, 10
convert_loop:
lb $t1, 0($a0) 
beq $t1, $0, convert_end 
beq $t1, 10, convert_end 
slti $t0, $t1, 48
bne $t0, $0, convert_error
li $t4, 57 
beq $t1, $t4, valid_digit 
slt $t0, $t1, $t4 
beq $t0, $0, convert_error
valid_digit:
addi $t1, $t1, -48 
mult $v0, $t3 
mflo $v0 
add $v0, $v0, $t1 
addi $a0, $a0, 1 
j convert_loop 
convert_error:
li $v1, 1 
li $v0, 0 
li $t2, 0 
convert_end:
beq $t2, $0, convert_ret
xori $v0, $v0, -1 
addi $v0, $v0, 1 
convert_ret:
jr $ra
print_bin:
move $t2, $a0 
print_bin_loop:
slti $a0, $t2, 0 
addi $a0, $a0, 48
li $v0, 11 
syscall 
sll $t2, $t2, 1
addi $a1, $a1, -1
bne $a1, $0, print_bin_loop
jr $ra
