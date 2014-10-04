	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m1__B__B:
	addi $sp, $sp, -4
	sw   $ra, -4($sp)
	jal  _m0__A__A
	lw   $ra, -4($sp)
	addi $sp, $sp, 4
	jr   $ra
_m0__A__A:
	addi $sp, $sp, -4
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -8
	sw   $s0, 0($sp)
	li   $a0, 8
	li   $v0, 9
	syscall
	move $s0, $v0
	la   $t0, _vt__A__A
	sw   $t0, 0($s0)
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m0__A__A
	lw   $ra, -4($sp)
	li   $t0, 0
	sw   $t0, 4($s0)
	lw   $a0, 4($s0)
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	li   $a0, 12
	li   $v0, 9
	syscall
	move $s0, $v0
	la   $t0, _vt__B__B
	sw   $t0, 0($s0)
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m1__B__B
	lw   $ra, -4($sp)
	li   $t0, 1
	sw   $t0, 8($s0)
	lw   $a0, 8($s0)
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	lw   $a0, 4($s0)
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	lw   $s0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "\n"
_s__2:
	.asciiz "\n"
_vt__A__A:
_vt__B__B:

