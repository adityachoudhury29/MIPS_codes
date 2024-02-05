.data
prompt: .asciiz "Enter number of rows: "
prompt2: .asciiz "Enter number of columns"
msg: .asciiz"Enter matrix elements:"
newline: .asciiz"\n"

.text
.globl main

main:
#Taking input no.of rows
li $v0,4
la $a0,prompt
syscall

li $v0,5
syscall
move $t0,$v0

#Taking input no.of columns
li $v0,4
la $a0,prompt2
syscall

li $v0,5
syscall
move $t1,$v0

#Calculating the number of elements in the matrix
mul $t2,$t0,$t1

#Allocate space dynamically
li $v0,9
move $a0,$t2
syscall
move $t3,$v0

#Prompt user for the matrix
la $a0,msg
li $v0,4
syscall

#Read elements
move $t4,$t3
li $t7,0

#Loop for reading the matrix elments
read_loop:
beq $t7,$t2,print_matrix

li $v0,5#Taking input
syscall
sw $v0,0($t4)

addi $t4,$t4,4#updating:4 as size of integer is 4
addi $t7,$t7,1
j read_loop

print_matrix:
move $t4,$t3
li $t5,0

outer_loop:
beq $t5,$t0,end_program
li $t6,0

inner_loop:
beq $t6,$t1,newline_print
lw $a0,0($t4)
li $v0,1
syscall

li $v0,11
li $a0,' '
syscall

addi $t4,$t4,4
addi $t6,$t6,1
j inner_loop

newline_print:
li $v0,4
la $a0,newline
syscall

addi $t5,$t5,1
j outer_loop

end_program:
li $v0,10
syscall

