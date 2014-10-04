	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $t0, 42
	move $a0, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	li   $t1, 1
	bnez $t1, L32
	li   $a0, 2
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
L16:
	move $a0, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__3
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
L32:
	li   $a0, 1
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	b    L16
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "\n"
_s__2:
	.asciiz "\n"
_s__3:
	.asciiz "\n"

