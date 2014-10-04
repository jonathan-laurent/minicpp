	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $t0, 1
	bnez $t0, L23
L10:
	addi $sp, $sp, 4
	jr   $ra
L23:
	li   $t0, 0
	bnez $t0, L10
	li   $t1, 1
	li   $t0, 2
	beq  $t1, $t0, L18
	la   $a0, _s__0
	li   $v0, 4
	syscall
	b    L10
L18:
	li   $t1, 0
	li   $t0, 0
	div  $a0, $t1, $t0
	li   $v0, 1
	syscall
	b    L10
	b    L10
	.data
_s__0:
	.asciiz "hello world\n"

