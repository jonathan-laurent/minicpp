	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $a0, 1
	move $t0, $a0
	move $t1, $a0
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	move $a0, $t1
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	move $a0, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz " "
_s__2:
	.asciiz " "

