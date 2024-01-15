.data
	test:.double 7.202
	final:.double 0.0
.text
	ldc1 $f2, test
	ldc1 $f0, final
	li $v0, 3
	add.d $f12,$f2,$f0
	syscall