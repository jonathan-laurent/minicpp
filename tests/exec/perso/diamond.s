	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m0__D__D:
	addi $sp, $sp, -8
	sw   $s0, 0($sp)
	move $s0, $a0
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m2__B__B
	lw   $ra, -4($sp)
	addi $a0, $s0, 12
	sw   $ra, -4($sp)
	jal  _m3__C__C
	lw   $ra, -4($sp)
	lw   $s0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
_m3__C__C:
	addi $sp, $sp, -4
	sw   $ra, -4($sp)
	jal  _m1__A__A
	lw   $ra, -4($sp)
	addi $sp, $sp, 4
	jr   $ra
_m2__B__B:
	addi $sp, $sp, -4
	sw   $ra, -4($sp)
	jal  _m1__A__A
	lw   $ra, -4($sp)
	addi $sp, $sp, 4
	jr   $ra
_m1__A__A:
	addi $sp, $sp, -4
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -8
	sw   $s0, 0($sp)
	li   $a0, 28
	li   $v0, 9
	syscall
	move $s0, $v0
	la   $t0, _vt__D__D
	sw   $t0, 0($s0)
	la   $t0, _vt__D__C
	sw   $t0, 12($s0)
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m0__D__D
	lw   $ra, -4($sp)
	li   $t0, 42
	sw   $t0, 4($s0)
	lw   $a0, 4($s0)
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _p1__f
	lw   $ra, -4($sp)
	li   $v0, 0
	lw   $s0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
_p1__f:
	addi $sp, $sp, -4
	lw   $a0, 4($a0)
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "\n"
_vt__A__A:
_vt__B__B:
_vt__C__C:
_vt__D__D:
_vt__D__C:

