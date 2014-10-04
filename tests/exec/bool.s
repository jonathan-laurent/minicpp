	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $a0, 1
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	li   $a0, 0
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "\n"

