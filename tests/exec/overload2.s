	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m0__A__A:
	addi $sp, $sp, -4
	sw   $a1, 4($a0)
	addi $sp, $sp, 4
	jr   $ra
_m1__A__A:
	addi $sp, $sp, -4
	li   $t0, 1
	sw   $t0, 4($a0)
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
	jal  _m1__A__A
	lw   $ra, -4($sp)
	lw   $t1, 4($s0)
	li   $t0, 1
	beq  $t1, $t0, L75
L57:
	lw   $s0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
L75:
	li   $a0, 8
	li   $v0, 9
	syscall
	move $s0, $v0
	la   $t0, _vt__A__A
	sw   $t0, 0($s0)
	li   $a1, 2
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m0__A__A
	lw   $ra, -4($sp)
	lw   $t1, 4($s0)
	li   $t0, 2
	bne  $t1, $t0, L57
	la   $a0, _s__0
	li   $v0, 4
	syscall
	b    L57
	b    L57
	.data
_s__0:
	.asciiz "ok\n"
_vt__A__A:

