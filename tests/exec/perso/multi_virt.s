	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m8__E__h:
	addi $sp, $sp, -4
	la   $a0, _s__11
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_m6__E__fd:
	addi $sp, $sp, -4
	la   $a0, _s__10
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_m7__E__fb:
	addi $sp, $sp, -4
	la   $a0, _s__9
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_m9__E__E:
	addi $sp, $sp, -8
	sw   $s0, 0($sp)
	move $s0, $a0
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m10__C__C
	lw   $ra, -4($sp)
	addi $a0, $s0, 20
	sw   $ra, -4($sp)
	jal  _m13__D__D
	lw   $ra, -4($sp)
	lw   $s0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
_m5__D__h:
	addi $sp, $sp, -4
	la   $a0, _s__8
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_m4__D__fd:
	addi $sp, $sp, -4
	la   $a0, _s__7
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_m13__D__D:
	addi $sp, $sp, -4
	addi $sp, $sp, 4
	jr   $ra
_m3__C__fc:
	addi $sp, $sp, -4
	la   $a0, _s__6
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_m10__C__C:
	addi $sp, $sp, -8
	sw   $s0, 0($sp)
	move $s0, $a0
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m11__A__A
	lw   $ra, -4($sp)
	addi $a0, $s0, 8
	sw   $ra, -4($sp)
	jal  _m12__B__B
	lw   $ra, -4($sp)
	lw   $s0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
_m2__B__h:
	addi $sp, $sp, -4
	la   $a0, _s__5
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_m1__B__fb:
	addi $sp, $sp, -4
	la   $a0, _s__4
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_m12__B__B:
	addi $sp, $sp, -4
	addi $sp, $sp, 4
	jr   $ra
_m0__A__fa:
	addi $sp, $sp, -4
	la   $a0, _s__3
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_m11__A__A:
	addi $sp, $sp, -4
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -8
	sw   $s0, 0($sp)
	li   $a0, 32
	li   $v0, 9
	syscall
	move $s0, $v0
	la   $t0, _vt__E__E
	sw   $t0, 0($s0)
	la   $t0, _vt__E__B
	sw   $t0, 8($s0)
	la   $t0, _vt__E__D
	sw   $t0, 20($s0)
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m9__E__E
	lw   $ra, -4($sp)
	addi $t0, $s0, 20
	lw   $t2, 0($t0)
	lw   $t1, 8($t2)
	add  $a0, $t1, $t0
	lw   $t1, 12($t2)
	sw   $ra, -4($sp)
	jalr $t1
	lw   $ra, -4($sp)
	la   $a0, _s__0
	li   $v0, 4
	syscall
	li   $a0, 32
	li   $v0, 9
	syscall
	move $s0, $v0
	la   $t0, _vt__E__E
	sw   $t0, 0($s0)
	la   $t0, _vt__E__B
	sw   $t0, 8($s0)
	la   $t0, _vt__E__D
	sw   $t0, 20($s0)
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m9__E__E
	lw   $ra, -4($sp)
	addi $t0, $s0, 20
	lw   $t2, 0($t0)
	lw   $t1, 0($t2)
	add  $a0, $t1, $t0
	lw   $t1, 4($t2)
	sw   $ra, -4($sp)
	jalr $t1
	lw   $ra, -4($sp)
	la   $a0, _s__1
	li   $v0, 4
	syscall
	li   $a0, 20
	li   $v0, 9
	syscall
	move $s0, $v0
	la   $t0, _vt__C__C
	sw   $t0, 0($s0)
	la   $t0, _vt__C__B
	sw   $t0, 8($s0)
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m10__C__C
	lw   $ra, -4($sp)
	lw   $t1, 0($s0)
	lw   $t0, 0($t1)
	add  $a0, $t0, $s0
	lw   $t0, 4($t1)
	sw   $ra, -4($sp)
	jalr $t0
	lw   $ra, -4($sp)
	la   $a0, _s__2
	li   $v0, 4
	syscall
	li   $v0, 0
	lw   $s0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "\n"
_s__10:
	.asciiz "E::fd"
_s__11:
	.asciiz "E::h"
_s__2:
	.asciiz "\n"
_s__3:
	.asciiz "A::fa"
_s__4:
	.asciiz "B::fb"
_s__5:
	.asciiz "B::h"
_s__6:
	.asciiz "E::fc"
_s__7:
	.asciiz "D::fd"
_s__8:
	.asciiz "D::h"
_s__9:
	.asciiz "E::fb"
_vt__A__A:
	.word 0
	.word _m0__A__fa
_vt__B__B:
	.word 0
	.word _m1__B__fb
	.word 0
	.word _m2__B__h
_vt__C__C:
	.word 0
	.word _m0__A__fa
	.word 0
	.word _m3__C__fc
_vt__C__B:
	.word 0
	.word _m1__B__fb
	.word 0
	.word _m2__B__h
_vt__D__D:
	.word 0
	.word _m4__D__fd
	.word 0
	.word _m5__D__h
_vt__E__E:
	.word 0
	.word _m0__A__fa
	.word 0
	.word _m3__C__fc
	.word 0
	.word _m6__E__fd
_vt__E__B:
	.word -8
	.word _m7__E__fb
	.word -8
	.word _m8__E__h
_vt__E__D:
	.word -20
	.word _m6__E__fd
	.word -20
	.word _m8__E__h

