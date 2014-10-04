	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m0__A__A:
	addi $sp, $sp, -4
	la   $a0, _s__1
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -4
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
	.data
_s__0:
	.asciiz "no hello world\n"
_s__1:
	.asciiz "hello world\n"
_vt__A__A:

