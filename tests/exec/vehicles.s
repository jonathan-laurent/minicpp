	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m0__Vehicle__move:
	addi $sp, $sp, -4
	move $t0, $a0
	la   $a0, _s__15
	li   $v0, 4
	syscall
	lw   $t1, 4($t0)
	add  $t1, $t1, $a1
	sw   $t1, 4($t0)
	addi $sp, $sp, 4
	jr   $ra
_m5__Vehicle__Vehicle:
	addi $sp, $sp, -4
	li   $t0, 10
	sw   $t0, 4($a0)
	addi $sp, $sp, 4
	jr   $ra
_m1__Truck__move:
	addi $sp, $sp, -4
	move $t0, $a0
	la   $a0, _s__14
	li   $v0, 4
	syscall
	li   $t1, 55
	sle  $t1, $a1, $t1
	bnez $t1, L75
	lw   $t2, 4($t0)
	li   $t1, 55
	add  $t1, $t2, $t1
	sw   $t1, 4($t0)
L63:
	addi $sp, $sp, 4
	jr   $ra
L75:
	lw   $t1, 4($t0)
	add  $t1, $t1, $a1
	sw   $t1, 4($t0)
	b    L63
_m2__Truck__Truck:
	addi $sp, $sp, -4
	sw   $ra, -4($sp)
	jal  _m5__Vehicle__Vehicle
	lw   $ra, -4($sp)
	addi $sp, $sp, 4
	jr   $ra
_m4__Car__await:
	addi $sp, $sp, -4
	move $t0, $a0
	la   $a0, _s__13
	li   $v0, 4
	syscall
	lw   $a0, 4($a1)
	li   $v0, 1
	syscall
	la   $a0, _s__12
	li   $v0, 4
	syscall
	lw   $t2, 4($a1)
	lw   $t1, 4($t0)
	slt  $t1, $t2, $t1
	bnez $t1, L154
	li   $a1, 10
	lw   $t2, 0($t0)
	lw   $t1, 0($t2)
	add  $a0, $t1, $t0
	lw   $t1, 4($t2)
	sw   $ra, -4($sp)
	jalr $t1
	lw   $ra, -4($sp)
L128:
	addi $sp, $sp, 4
	jr   $ra
L154:
	lw   $t1, 4($t0)
	lw   $t0, 4($a1)
	sub  $t2, $t1, $t0
	lw   $t1, 0($a1)
	lw   $t0, 0($t1)
	add  $a0, $t0, $a1
	lw   $t0, 4($t1)
	sw   $ra, -4($sp)
	move $a1, $t2
	jalr $t0
	lw   $ra, -4($sp)
	b    L128
_m3__Car__Car:
	addi $sp, $sp, -4
	sw   $ra, -4($sp)
	jal  _m5__Vehicle__Vehicle
	lw   $ra, -4($sp)
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -28
	addi $t1, $sp, 0
	la   $t0, _vt__Truck__Truck
	sw   $t0, 0($t1)
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m2__Truck__Truck
	lw   $ra, -4($sp)
	la   $a0, _s__1
	li   $v0, 4
	syscall
	lw   $a0, 4($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $t1, $sp, 12
	la   $t0, _vt__Car__Car
	sw   $t0, 0($t1)
	addi $a0, $sp, 12
	sw   $ra, -4($sp)
	jal  _m3__Car__Car
	lw   $ra, -4($sp)
	li   $t0, 2
	sw   $t0, 20($sp)
	la   $a0, _s__3
	li   $v0, 4
	syscall
	lw   $a0, 16($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	li   $a1, 60
	addi $t2, $sp, 12
	lw   $t1, 0($t2)
	lw   $t0, 0($t1)
	add  $a0, $t0, $t2
	lw   $t0, 4($t1)
	sw   $ra, -4($sp)
	jalr $t0
	lw   $ra, -4($sp)
	la   $a0, _s__5
	li   $v0, 4
	syscall
	lw   $a0, 16($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__4
	li   $v0, 4
	syscall
	addi $t0, $sp, 12
	li   $a1, 70
	lw   $t2, 0($t0)
	lw   $t1, 0($t2)
	add  $a0, $t1, $t0
	lw   $t1, 4($t2)
	sw   $ra, -4($sp)
	jalr $t1
	lw   $ra, -4($sp)
	la   $a0, _s__7
	li   $v0, 4
	syscall
	lw   $a0, 16($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__6
	li   $v0, 4
	syscall
	addi $a0, $sp, 12
	addi $a1, $sp, 0
	sw   $ra, -4($sp)
	jal  _m4__Car__await
	lw   $ra, -4($sp)
	la   $a0, _s__9
	li   $v0, 4
	syscall
	lw   $a0, 4($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__8
	li   $v0, 4
	syscall
	la   $a0, _s__11
	li   $v0, 4
	syscall
	lw   $a0, 16($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__10
	li   $v0, 4
	syscall
	addi $sp, $sp, 28
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "t at "
_s__10:
	.asciiz "\n"
_s__11:
	.asciiz "c at "
_s__12:
	.asciiz "\n"
_s__13:
	.asciiz "await: position = "
_s__14:
	.asciiz "truck moves\n"
_s__15:
	.asciiz "vehicle moves\n"
_s__2:
	.asciiz "\n"
_s__3:
	.asciiz "c at "
_s__4:
	.asciiz "\n"
_s__5:
	.asciiz "c at "
_s__6:
	.asciiz "\n"
_s__7:
	.asciiz "c at "
_s__8:
	.asciiz "\n"
_s__9:
	.asciiz "t at "
_vt__Car__Car:
	.word 0
	.word _m0__Vehicle__move
_vt__Truck__Truck:
	.word 0
	.word _m1__Truck__move
_vt__Vehicle__Vehicle:
	.word 0
	.word _m0__Vehicle__move

