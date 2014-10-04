	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $t0, 1
	li   $t1, 0
	bnez $t0, L16
L10:
	addi $sp, $sp, 4
	jr   $ra
L16:
	li   $t0, 0
	bne  $t1, $t0, L10
	la   $a0, _s__0
	li   $v0, 4
	syscall
	b    L10
	b    L10
	.data
_s__0:
	.asciiz "non, tous les programmes n'affichent pas hello world\n"

