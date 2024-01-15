.data
	character:.byte 'a'
.text
	li $v0, 11
	la $a0, character
	syscall