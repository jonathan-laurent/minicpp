	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $t1, 0
L57:
	li   $t2, 5
	slt  $t2, $t1, $t2
	bnez $t2, L53
	la   $a0, _s__3
	li   $v0, 4
	syscall
	move $a0, $t1
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	la   $a0, _s__5
	li   $v0, 4
	syscall
	move $a0, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__4
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
L53:
	li   $t0, 0
L51:
	li   $t2, 5
	slt  $t2, $t0, $t2
	bnez $t2, L47
	addi $t1, $t1, 1
	b    L57
L47:
	la   $a0, _s__1
	li   $v0, 4
	syscall
	mul  $a0, $t1, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $t0, $t0, 1
	b    L51
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "i*j = "
_s__2:
	.asciiz "\n"
_s__3:
	.asciiz "i = "
_s__4:
	.asciiz "\n"
_s__5:
	.asciiz "j = "

