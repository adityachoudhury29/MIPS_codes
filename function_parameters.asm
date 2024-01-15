.data
	char: .byte '\n'
.text
	main:
		li $v0, 5
		syscall
		move $t4, $v0
		li $v0, 5
		syscall
		move $t5, $v0
		jal addnumbers
		li $v0, 1
		syscall
		li $v0, 10
		syscall
	
	addnumbers:
		add $a0, $t4, $t5
		jr $ra