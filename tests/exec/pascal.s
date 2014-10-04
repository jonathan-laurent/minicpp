	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m1__Array__set:
	addi $sp, $sp, -4
	li   $t0, 0
	beq  $a1, $t0, L25
	lw   $a0, 4($a0)
	li   $t0, 1
	sub  $a1, $a1, $t0
	sw   $ra, -4($sp)
	jal  _m1__Array__set
	lw   $ra, -4($sp)
L10:
	addi $sp, $sp, 4
	jr   $ra
L25:
	sw   $a2, 8($a0)
	b    L10
_m0__Array__get:
	addi $sp, $sp, -4
	li   $t0, 0
	beq  $a1, $t0, L65
	lw   $a0, 4($a0)
	li   $t0, 1
	sub  $a1, $a1, $t0
	sw   $ra, -4($sp)
	jal  _m0__Array__get
	lw   $ra, -4($sp)
L50:
	addi $sp, $sp, 4
	jr   $ra
L65:
	lw   $v0, 8($a0)
	b    L50
_m2__Array__Array:
	addi $sp, $sp, -12
	sw   $s0, 4($sp)
	sw   $s1, 0($sp)
	move $s0, $a0
	li   $t0, 1
	beq  $a1, $t0, L106
	li   $a0, 12
	li   $v0, 9
	syscall
	move $s1, $v0
	la   $t0, _vt__Array__Array
	sw   $t0, 0($s1)
	li   $t0, 1
	sub  $a1, $a1, $t0
	sw   $ra, -4($sp)
	move $a0, $s1
	jal  _m2__Array__Array
	lw   $ra, -4($sp)
	sw   $s1, 4($s0)
L89:
	lw   $s0, 4($sp)
	lw   $s1, 0($sp)
	addi $sp, $sp, 12
	jr   $ra
L106:
	b    L89
_p2__print_row:
	addi $sp, $sp, -16
	sw   $s0, 8($sp)
	sw   $s1, 4($sp)
	sw   $s2, 0($sp)
	move $s2, $a0
	move $s1, $a1
	li   $s0, 0
L157:
	sle  $t0, $s0, $s1
	bnez $t0, L153
	la   $a0, _s__2
	li   $v0, 4
	syscall
	lw   $s0, 8($sp)
	lw   $s1, 4($sp)
	lw   $s2, 0($sp)
	addi $sp, $sp, 16
	jr   $ra
L153:
	sw   $ra, -4($sp)
	move $a0, $s2
	move $a1, $s0
	jal  _m0__Array__get
	lw   $ra, -4($sp)
	li   $t0, 0
	bne  $v0, $t0, L143
	la   $a0, _s__0
	li   $v0, 4
	syscall
L137:
	addi $s0, $s0, 1
	b    L157
L143:
	la   $a0, _s__1
	li   $v0, 4
	syscall
	b    L137
_p0__main:
	addi $sp, $sp, -16
	sw   $s0, 8($sp)
	sw   $s1, 4($sp)
	sw   $s2, 0($sp)
	li   $s0, 42
	li   $a0, 12
	li   $v0, 9
	syscall
	move $s1, $v0
	la   $t0, _vt__Array__Array
	sw   $t0, 0($s1)
	li   $t0, 1
	add  $a1, $s0, $t0
	sw   $ra, -4($sp)
	move $a0, $s1
	jal  _m2__Array__Array
	lw   $ra, -4($sp)
	li   $s2, 0
L211:
	slt  $t0, $s2, $s0
	bnez $t0, L207
	lw   $s0, 8($sp)
	lw   $s1, 4($sp)
	lw   $s2, 0($sp)
	addi $sp, $sp, 16
	jr   $ra
L207:
	li   $a2, 0
	sw   $ra, -4($sp)
	move $a0, $s1
	move $a1, $s2
	jal  _m1__Array__set
	lw   $ra, -4($sp)
	sw   $ra, -4($sp)
	move $a0, $s1
	move $a1, $s2
	jal  _p1__compute_row
	lw   $ra, -4($sp)
	sw   $ra, -4($sp)
	move $a0, $s1
	move $a1, $s2
	jal  _p2__print_row
	lw   $ra, -4($sp)
	addi $s2, $s2, 1
	b    L211
_p1__compute_row:
	addi $sp, $sp, -16
	sw   $s0, 8($sp)
	sw   $s1, 4($sp)
	sw   $s2, 0($sp)
	move $s1, $a0
	move $s0, $a1
	li   $a2, 0
	li   $t0, 0
	beq  $s0, $t0, L295
	sw   $ra, -4($sp)
	move $a0, $s1
	move $a1, $s0
	jal  _m0__Array__get
	lw   $ra, -4($sp)
	move $s2, $v0
	li   $t0, 1
	sub  $a1, $s0, $t0
	sw   $ra, -4($sp)
	move $a0, $s1
	jal  _m0__Array__get
	lw   $ra, -4($sp)
	add  $t1, $s2, $v0
	li   $t0, 7
	rem  $a2, $t1, $t0
L271:
	sw   $ra, -4($sp)
	move $a0, $s1
	move $a1, $s0
	jal  _m1__Array__set
	lw   $ra, -4($sp)
	li   $t0, 0
	sgt  $t0, $s0, $t0
	bnez $t0, L258
L249:
	lw   $s0, 8($sp)
	lw   $s1, 4($sp)
	lw   $s2, 0($sp)
	addi $sp, $sp, 16
	jr   $ra
L258:
	li   $t0, 1
	sub  $a1, $s0, $t0
	sw   $ra, -4($sp)
	move $a0, $s1
	jal  _p1__compute_row
	lw   $ra, -4($sp)
	b    L249
L295:
	li   $a2, 1
	b    L271
	.data
_s__0:
	.asciiz "0"
_s__1:
	.asciiz "*"
_s__2:
	.asciiz "\n"
_vt__Array__Array:

