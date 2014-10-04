	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m6__C__g:
	addi $sp, $sp, -4
	lw   $t0, 16($a0)
	mul  $t1, $a1, $t0
	li   $t0, 404
	mul  $v0, $t1, $t0
	addi $sp, $sp, 4
	jr   $ra
_m1__C__f:
	addi $sp, $sp, -4
	lw   $t0, 16($a0)
	mul  $v0, $a1, $t0
	addi $sp, $sp, 4
	jr   $ra
_m5__C__C:
	addi $sp, $sp, -8
	sw   $s0, 0($sp)
	move $s0, $a0
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m2__A__A
	lw   $ra, -4($sp)
	addi $a0, $s0, 8
	sw   $ra, -4($sp)
	jal  _m3__B__B
	lw   $ra, -4($sp)
	li   $t0, 11
	sw   $t0, 16($s0)
	lw   $s0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
_m4__B__g:
	addi $sp, $sp, -4
	lw   $t0, 4($a0)
	mul  $v0, $a1, $t0
	addi $sp, $sp, 4
	jr   $ra
_m3__B__B:
	addi $sp, $sp, -4
	li   $t0, 7
	sw   $t0, 4($a0)
	addi $sp, $sp, 4
	jr   $ra
_m0__A__f:
	addi $sp, $sp, -4
	lw   $t0, 4($a0)
	mul  $v0, $a1, $t0
	addi $sp, $sp, 4
	jr   $ra
_m2__A__A:
	addi $sp, $sp, -4
	li   $t0, 12
	sw   $t0, 4($a0)
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -40
	addi $t1, $sp, 8
	la   $t0, _vt__A__A
	sw   $t0, 0($t1)
	addi $a0, $sp, 8
	sw   $ra, -4($sp)
	jal  _m2__A__A
	lw   $ra, -4($sp)
	la   $a0, _s__1
	li   $v0, 4
	syscall
	li   $a1, 1
	addi $t2, $sp, 8
	lw   $t1, 0($t2)
	lw   $t0, 0($t1)
	add  $a0, $t0, $t2
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
	addi $t1, $sp, 0
	la   $t0, _vt__B__B
	sw   $t0, 0($t1)
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m3__B__B
	lw   $ra, -4($sp)
	la   $a0, _s__3
	li   $v0, 4
	syscall
	addi $a0, $sp, 0
	li   $a1, 1
	sw   $ra, -4($sp)
	jal  _m4__B__g
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	addi $t1, $sp, 16
	la   $t0, _vt__C__C
	sw   $t0, 0($t1)
	la   $t0, _vt__C__B
	sw   $t0, 8($t1)
	addi $a0, $sp, 16
	sw   $ra, -4($sp)
	jal  _m5__C__C
	lw   $ra, -4($sp)
	la   $a0, _s__5
	li   $v0, 4
	syscall
	li   $a1, 1
	addi $t2, $sp, 16
	lw   $t1, 0($t2)
	lw   $t0, 0($t1)
	add  $a0, $t0, $t2
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
	la   $a0, _s__7
	li   $v0, 4
	syscall
	addi $a0, $sp, 16
	li   $a1, 1
	sw   $ra, -4($sp)
	jal  _m6__C__g
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__6
	li   $v0, 4
	syscall
	addi $t0, $sp, 16
	la   $a0, _s__9
	li   $v0, 4
	syscall
	li   $a1, 1
	lw   $t2, 0($t0)
	lw   $t1, 0($t2)
	add  $a0, $t1, $t0
	lw   $t1, 4($t2)
	sw   $ra, -4($sp)
	jalr $t1
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__8
	li   $v0, 4
	syscall
	addi $t0, $sp, 16
	addi $t0, $t0, 8
	la   $a0, _s__11
	li   $v0, 4
	syscall
	li   $a1, 1
	sw   $ra, -4($sp)
	move $a0, $t0
	jal  _m4__B__g
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__10
	li   $v0, 4
	syscall
	addi $sp, $sp, 40
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "A.f(1) = "
_s__10:
	.asciiz "\n"
_s__11:
	.asciiz "(C as B).g(1) = "
_s__2:
	.asciiz "\n"
_s__3:
	.asciiz "B.g(1) = "
_s__4:
	.asciiz "\n"
_s__5:
	.asciiz "C.f(1) = "
_s__6:
	.asciiz "\n"
_s__7:
	.asciiz "C.g(1) = "
_s__8:
	.asciiz "\n"
_s__9:
	.asciiz "(C as A).f(1) = "
_vt__A__A:
	.word 0
	.word _m0__A__f
_vt__B__B:
_vt__C__C:
	.word 0
	.word _m1__C__f
_vt__C__B:

