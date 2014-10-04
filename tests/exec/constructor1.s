	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m0__A__A:
	addi $sp, $sp, -4
	sw   $a1, 4($a0)
	sw   $a2, 8($a0)
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -16
	addi $t1, $sp, 0
	la   $t0, _vt__A__A
	sw   $t0, 0($t1)
	addi $a0, $sp, 0
	li   $a1, 17
	li   $a2, 42
	sw   $ra, -4($sp)
	jal  _m0__A__A
	lw   $ra, -4($sp)
	lw   $a0, 4($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	lw   $a0, 8($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	addi $sp, $sp, 16
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "\n"
_vt__A__A:

