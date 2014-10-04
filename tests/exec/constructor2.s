	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m0__A__A:
	addi $sp, $sp, -4
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -8
	addi $t1, $sp, 0
	la   $t0, _vt__A__A
	sw   $t0, 0($t1)
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m0__A__A
	lw   $ra, -4($sp)
	addi $sp, $sp, 8
	jr   $ra
	.data
_s__0:
	.asciiz "hello world\n"
_vt__A__A:

