.data
	character:.byte 'a'
.text
	li $v0, 11
	lb $a0, character
	syscall