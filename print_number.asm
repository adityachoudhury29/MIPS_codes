.data
	dec:.word 21
.text
	li $v0, 1
	lw $a0, dec
	syscall