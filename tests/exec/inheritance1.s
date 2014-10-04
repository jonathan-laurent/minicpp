	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m1__B__f:
	addi $sp, $sp, -4
	la   $a0, _s__3
	li   $v0, 4
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_m3__B__B:
	addi $sp, $sp, -4
	sw   $ra, -4($sp)
	jal  _m2__A__A
	lw   $ra, -4($sp)
	addi $sp, $sp, 4
	jr   $ra
_m0__A__f:
	addi $sp, $sp, -4
	la   $a0, _s__1
	li   $v0, 4
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_m2__A__A:
	addi $sp, $sp, -4
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -12
	addi $t1, $sp, 4
	la   $t0, _vt__A__A
	sw   $t0, 0($t1)
	addi $a0, $sp, 4
	sw   $ra, -4($sp)
	jal  _m2__A__A
	lw   $ra, -4($sp)
	addi $t2, $sp, 4
	lw   $t1, 0($t2)
	lw   $t0, 0($t1)
	add  $a0, $t0, $t2
	lw   $t0, 4($t1)
	sw   $ra, -4($sp)
	jalr $t0
	lw   $ra, -4($sp)
	addi $t1, $sp, 0
	la   $t0, _vt__B__B
	sw   $t0, 0($t1)
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m3__B__B
	lw   $ra, -4($sp)
	addi $t2, $sp, 0
	lw   $t1, 0($t2)
	lw   $t0, 0($t1)
	add  $a0, $t0, $t2
	lw   $t0, 4($t1)
	sw   $ra, -4($sp)
	jalr $t0
	lw   $ra, -4($sp)
	addi $t0, $sp, 0
	lw   $t2, 0($t0)
	lw   $t1, 0($t2)
	add  $a0, $t1, $t0
	lw   $t1, 4($t2)
	sw   $ra, -4($sp)
	jalr $t1
	lw   $ra, -4($sp)
	addi $t0, $sp, 4
	lw   $t2, 0($t0)
	lw   $t1, 0($t2)
	add  $a0, $t1, $t0
	lw   $t1, 4($t2)
	sw   $ra, -4($sp)
	jalr $t1
	lw   $ra, -4($sp)
	addi $sp, $sp, 12
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "this is A::f"
_s__2:
	.asciiz "\n"
_s__3:
	.asciiz "this is B::f"
_vt__A__A:
	.word 0
	.word _m0__A__f
_vt__B__B:
	.word 0
	.word _m1__B__f

