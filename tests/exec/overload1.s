	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m2__A__set_a:
	addi $sp, $sp, -4
	sw   $a1, 4($a0)
	addi $sp, $sp, 4
	jr   $ra
_m1__A__set_a:
	addi $sp, $sp, -4
	li   $t0, 1
	sw   $t0, 4($a0)
	addi $sp, $sp, 4
	jr   $ra
_m0__A__A:
	addi $sp, $sp, -4
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -16
	sw   $s0, 0($sp)
	addi $t1, $sp, 4
	la   $t0, _vt__A__A
	sw   $t0, 0($t1)
	addi $a0, $sp, 4
	sw   $ra, -4($sp)
	jal  _m0__A__A
	lw   $ra, -4($sp)
	addi $a0, $sp, 4
	sw   $ra, -4($sp)
	jal  _m1__A__set_a
	lw   $ra, -4($sp)
	lw   $t1, 8($sp)
	li   $t0, 1
	seq  $s0, $t1, $t0
	addi $a0, $sp, 4
	li   $a1, 2
	sw   $ra, -4($sp)
	jal  _m2__A__set_a
	lw   $ra, -4($sp)
	bnez $s0, L87
	li   $s0, 0
L83:
	bnez $s0, L80
L77:
	lw   $s0, 0($sp)
	addi $sp, $sp, 16
	jr   $ra
L80:
	la   $a0, _s__0
	li   $v0, 4
	syscall
	b    L77
L87:
	lw   $t1, 8($sp)
	li   $t0, 2
	seq  $s0, $t1, $t0
	b    L83
	.data
_s__0:
	.asciiz "ok\n"
_vt__A__A:

