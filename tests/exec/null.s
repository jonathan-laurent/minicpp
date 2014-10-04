	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m0__A__A:
	addi $sp, $sp, -4
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -12
	li   $t0, 0
	li   $t1, 0
	seq  $a0, $t0, $t1
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	li   $t0, 1
	sw   $t0, 0($sp)
	addi $t1, $sp, 0
	li   $t0, 0
	seq  $a0, $t1, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	addi $t1, $sp, 4
	la   $t0, _vt__A__A
	sw   $t0, 0($t1)
	addi $a0, $sp, 4
	sw   $ra, -4($sp)
	jal  _m0__A__A
	lw   $ra, -4($sp)
	addi $t1, $sp, 4
	li   $t0, 0
	seq  $a0, $t1, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	addi $sp, $sp, 12
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "\n"
_s__2:
	.asciiz "\n"
_vt__A__A:

