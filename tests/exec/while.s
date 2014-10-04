	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $t1, 0
	li   $t2, 0
L37:
	li   $t0, 10
	slt  $t0, $t1, $t0
	bnez $t0, L33
	li   $t0, 100
	beq  $t2, $t0, L13
L10:
	addi $sp, $sp, 4
	jr   $ra
L13:
	la   $a0, _s__0
	li   $v0, 4
	syscall
	b    L10
L33:
	li   $t0, 10
L31:
	li   $t3, 0
	sgt  $t3, $t0, $t3
	bnez $t3, L27
	addi $t1, $t1, 1
	b    L37
L27:
	addi $t2, $t2, 1
	addi $t0, $t0, -1
	b    L31
	.data
_s__0:
	.asciiz "ok\n"

