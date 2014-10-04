	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m1__C__f:
	addi $sp, $sp, -4
	lw   $t0, 16($a0)
	mul  $v0, $a1, $t0
	addi $sp, $sp, 4
	jr   $ra
_m0__C__C:
	addi $sp, $sp, -8
	sw   $s0, 0($sp)
	move $s0, $a0
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m4__A__A
	lw   $ra, -4($sp)
	addi $a0, $s0, 8
	sw   $ra, -4($sp)
	jal  _m5__B__B
	lw   $ra, -4($sp)
	li   $t0, 11
	sw   $t0, 16($s0)
	lw   $s0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
_m2__B__g:
	addi $sp, $sp, -4
	lw   $t0, 4($a0)
	mul  $v0, $a1, $t0
	addi $sp, $sp, 4
	jr   $ra
_m5__B__B:
	addi $sp, $sp, -4
	li   $t0, 7
	sw   $t0, 4($a0)
	addi $sp, $sp, 4
	jr   $ra
_m3__A__f:
	addi $sp, $sp, -4
	lw   $t0, 4($a0)
	mul  $v0, $a1, $t0
	addi $sp, $sp, 4
	jr   $ra
_m4__A__A:
	addi $sp, $sp, -4
	li   $t0, 12
	sw   $t0, 4($a0)
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -24
	addi $t1, $sp, 0
	la   $t0, _vt__C__C
	sw   $t0, 0($t1)
	la   $t0, _vt__C__B
	sw   $t0, 8($t1)
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m0__C__C
	lw   $ra, -4($sp)
	la   $a0, _s__1
	li   $v0, 4
	syscall
	addi $a0, $sp, 0
	li   $a1, 1
	sw   $ra, -4($sp)
	jal  _m1__C__f
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	la   $a0, _s__3
	li   $v0, 4
	syscall
	addi $a0, $sp, 0
	li   $a1, 1
	sw   $ra, -4($sp)
	jal  _m2__B__g
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	addi $t0, $sp, 0
	la   $a0, _s__5
	li   $v0, 4
	syscall
	li   $a1, 1
	sw   $ra, -4($sp)
	move $a0, $t0
	jal  _m3__A__f
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__4
	li   $v0, 4
	syscall
	addi $t0, $sp, 0
	addi $t0, $t0, 8
	la   $a0, _s__7
	li   $v0, 4
	syscall
	li   $a1, 1
	sw   $ra, -4($sp)
	move $a0, $t0
	jal  _m2__B__g
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__6
	li   $v0, 4
	syscall
	addi $sp, $sp, 24
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "C.f(1) = "
_s__2:
	.asciiz "\n"
_s__3:
	.asciiz "C.g(1) = "
_s__4:
	.asciiz "\n"
_s__5:
	.asciiz "A.f(1) = "
_s__6:
	.asciiz "\n"
_s__7:
	.asciiz "B.g(1) = "
_vt__A__A:
_vt__B__B:
_vt__C__C:
_vt__C__B:

