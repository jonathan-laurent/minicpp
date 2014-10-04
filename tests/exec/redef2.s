	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m1__C__f:
	addi $sp, $sp, -4
	li   $t0, 3
	mul  $v0, $t0, $a1
	addi $sp, $sp, 4
	jr   $ra
_m4__C__C:
	addi $sp, $sp, -4
	sw   $ra, -4($sp)
	jal  _m3__B__B
	lw   $ra, -4($sp)
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
	move $v0, $a1
	addi $sp, $sp, 4
	jr   $ra
_m2__A__A:
	addi $sp, $sp, -4
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -12
	sw   $s0, 4($sp)
	sw   $s1, 0($sp)
	li   $a0, 4
	li   $v0, 9
	syscall
	move $s0, $v0
	la   $t0, _vt__A__A
	sw   $t0, 0($s0)
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m2__A__A
	lw   $ra, -4($sp)
	li   $a1, 1
	lw   $t1, 0($s0)
	lw   $t0, 0($t1)
	add  $a0, $t0, $s0
	lw   $t0, 4($t1)
	sw   $ra, -4($sp)
	jalr $t0
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	li   $a0, 4
	li   $v0, 9
	syscall
	move $s0, $v0
	la   $t0, _vt__B__B
	sw   $t0, 0($s0)
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m3__B__B
	lw   $ra, -4($sp)
	li   $a1, 1
	lw   $t1, 0($s0)
	lw   $t0, 0($t1)
	add  $a0, $t0, $s0
	lw   $t0, 4($t1)
	sw   $ra, -4($sp)
	jalr $t0
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	li   $a0, 4
	li   $v0, 9
	syscall
	move $s1, $v0
	la   $t0, _vt__C__C
	sw   $t0, 0($s1)
	sw   $ra, -4($sp)
	move $a0, $s1
	jal  _m4__C__C
	lw   $ra, -4($sp)
	li   $a1, 1
	lw   $t1, 0($s1)
	lw   $t0, 0($t1)
	add  $a0, $t0, $s1
	lw   $t0, 4($t1)
	sw   $ra, -4($sp)
	jalr $t0
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	li   $a1, 1
	lw   $t1, 0($s0)
	lw   $t0, 0($t1)
	add  $a0, $t0, $s0
	lw   $t0, 4($t1)
	sw   $ra, -4($sp)
	jalr $t0
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__3
	li   $v0, 4
	syscall
	move $s0, $s1
	li   $a1, 1
	lw   $t1, 0($s0)
	lw   $t0, 0($t1)
	add  $a0, $t0, $s0
	lw   $t0, 4($t1)
	sw   $ra, -4($sp)
	jalr $t0
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__4
	li   $v0, 4
	syscall
	move $s0, $s1
	li   $a1, 1
	lw   $t1, 0($s0)
	lw   $t0, 0($t1)
	add  $a0, $t0, $s0
	lw   $t0, 4($t1)
	sw   $ra, -4($sp)
	jalr $t0
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__5
	li   $v0, 4
	syscall
	lw   $s0, 4($sp)
	lw   $s1, 0($sp)
	addi $sp, $sp, 12
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "\n"
_s__2:
	.asciiz "\n"
_s__3:
	.asciiz "\n"
_s__4:
	.asciiz "\n"
_s__5:
	.asciiz "\n"
_vt__A__A:
	.word 0
	.word _m0__A__f
_vt__B__B:
	.word 0
	.word _m0__A__f
_vt__C__C:
	.word 0
	.word _m1__C__f

