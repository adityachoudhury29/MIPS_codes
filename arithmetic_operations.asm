.data
    prompt1: .asciiz "Enter the first number: "
    prompt2: .asciiz "Enter the second number: "
    result_add: .asciiz "Addition result: "
    result_sub: .asciiz "Subtraction result: "
    result_mul: .asciiz "Multiplication result: "
    result_div: .asciiz "Division result: "
    newline: .asciiz "\n"

.text
    main:
        # Prompt for the first number
        li $v0, 4
        la $a0, prompt1
        syscall

        # Read the first number
        li $v0, 5
        syscall
        move $s0, $v0

        # Prompt for the second number
        li $v0, 4
        la $a0, prompt2
        syscall

        # Read the second number
        li $v0, 5
        syscall
        move $s1, $v0

        # Addition
        add $t0, $s0, $s1
        li $v0, 4
        la $a0, result_add
        syscall
        li $v0, 1
        move $a0, $t0
        syscall
        li $v0, 4
        la $a0, newline
        syscall

        # Subtraction
        sub $t1, $s0, $s1
        li $v0, 4
        la $a0, result_sub
        syscall
        li $v0, 1
        move $a0, $t1
        syscall
        li $v0, 4
        la $a0, newline
        syscall

        # Multiplication
        mul $t2, $s0, $s1
        li $v0, 4
        la $a0, result_mul
        syscall
        li $v0, 1
        move $a0, $t2
        syscall
        li $v0, 4
        la $a0, newline
        syscall

        # Division
        div $s0, $s1
        mflo $t3
        li $v0, 4
        la $a0, result_div
        syscall
        li $v0, 1
        move $a0, $t3
        syscall
        li $v0, 4
        la $a0, newline
        syscall

        # Exit
        li $v0, 10
        syscall
