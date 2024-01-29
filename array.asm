.data
array: .space 20
msg_input: .asciiz "Enter value %d: "
msg_output: .asciiz "\nThe values entered are: \n"

.text
.globl main

main:
li $t0,0
la $t1, array

la $a0,msg_input
li $v0,4
syscall

#Loop to fill the array with elements
fill_loop:
li $v0,5
syscall
sw $v0, 0($t1)

#Incrementing addresses
addi $t0, $t0,1
addi $t1,$t1,4

#Looping condition
bne $t0,5,fill_loop

#exit
la $a0,msg_output
li $v0,4
syscall

li $t0,0
la $t1, array

#Loop to print the array with elements
print_loop:
lw $a0, 0($t1)
li $v0, 1
syscall
#Incrementing addresses
addi $t0,$t0,1
addi $t1,$t1,4

#Printing
li $v0,11
li $a0,10
syscall

#Looping condition
bne $t0,5,print_loop

li $v0,10
syscall
