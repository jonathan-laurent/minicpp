	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m1__Array__set:
	addi $sp, $sp, -4
	li   $a3, 0
	beq  $a1, $a3, L26
	lw   $a3, 4($a0)
	addi $a3, $a3, 0
	li   $a0, 1
	sub  $a1, $a1, $a0
	sw   $ra, -4($sp)
	move $a0, $a3
	jal  _m1__Array__set
	lw   $ra, -4($sp)
L10:
	addi $sp, $sp, 4
	jr   $ra
L26:
	sw   $a2, 8($a0)
	b    L10
_m0__Array__get:
	addi $sp, $sp, -4
	li   $a2, 0
	beq  $a1, $a2, L70
	lw   $a2, 4($a0)
	addi $a2, $a2, 0
	li   $a0, 1
	sub  $a1, $a1, $a0
	sw   $ra, -4($sp)
	move $a0, $a2
	jal  _m0__Array__get
	lw   $ra, -4($sp)
L54:
	addi $sp, $sp, 4
	jr   $ra
L70:
	lw   $v0, 8($a0)
	b    L54
_m2__Array__Array:
	addi $sp, $sp, -12
	sw   $s0, 4($sp)
	sw   $s1, 0($sp)
	move $s0, $a0
	li   $a0, 1
	beq  $a1, $a0, L113
	li   $a0, 12
	li   $v0, 9
	syscall
	move $s1, $v0
	la   $a0, _vt__Array__Array
	sw   $a0, 0($s1)
	li   $a0, 1
	sub  $a1, $a1, $a0
	sw   $ra, -4($sp)
	move $a0, $s1
	jal  _m2__Array__Array
	lw   $ra, -4($sp)
	sw   $s1, 4($s0)
L96:
	lw   $s0, 4($sp)
	lw   $s1, 0($sp)
	addi $sp, $sp, 12
	jr   $ra
L113:
	b    L96
_p2__print_row:
	addi $sp, $sp, -16
	sw   $s0, 8($sp)
	sw   $s1, 4($sp)
	sw   $s2, 0($sp)
	move $s2, $a0
	move $s1, $a1
	li   $s0, 0
L167:
	sle  $a0, $s0, $s1
	bnez $a0, L163
	la   $a0, _s__2
	li   $v0, 4
	syscall
	lw   $s0, 8($sp)
	lw   $s1, 4($sp)
	lw   $s2, 0($sp)
	addi $sp, $sp, 16
	jr   $ra
L163:
	move $a0, $s2
	addi $a0, $a0, 0
	sw   $ra, -4($sp)
	move $a1, $s0
	jal  _m0__Array__get
	lw   $ra, -4($sp)
	li   $a0, 0
	bne  $v0, $a0, L152
	la   $a0, _s__0
	li   $v0, 4
	syscall
L146:
	addi $s0, $s0, 1
	b    L167
L152:
	la   $a0, _s__1
	li   $v0, 4
	syscall
	b    L146
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
	la   $a0, _vt__Array__Array
	sw   $a0, 0($s1)
	li   $a0, 1
	add  $a1, $s0, $a0
	sw   $ra, -4($sp)
	move $a0, $s1
	jal  _m2__Array__Array
	lw   $ra, -4($sp)
	li   $s2, 0
L225:
	slt  $a0, $s2, $s0
	bnez $a0, L221
	lw   $s0, 8($sp)
	lw   $s1, 4($sp)
	lw   $s2, 0($sp)
	addi $sp, $sp, 16
	jr   $ra
L221:
	move $a0, $s1
	addi $a0, $a0, 0
	li   $a2, 0
	sw   $ra, -4($sp)
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
	b    L225
_p1__compute_row:
	addi $sp, $sp, -16
	sw   $s0, 8($sp)
	sw   $s1, 4($sp)
	sw   $s2, 0($sp)
	move $s2, $a0
	move $s0, $a1
	li   $a2, 0
	li   $a0, 0
	beq  $s0, $a0, L314
	move $a0, $s2
	addi $a0, $a0, 0
	sw   $ra, -4($sp)
	move $a1, $s0
	jal  _m0__Array__get
	lw   $ra, -4($sp)
	move $s1, $v0
	move $a2, $s2
	addi $a2, $a2, 0
	li   $a0, 1
	sub  $a1, $s0, $a0
	sw   $ra, -4($sp)
	move $a0, $a2
	jal  _m0__Array__get
	lw   $ra, -4($sp)
	add  $a1, $s1, $v0
	li   $a0, 7
	rem  $a2, $a1, $a0
L288:
	move $a0, $s2
	addi $a0, $a0, 0
	sw   $ra, -4($sp)
	move $a1, $s0
	jal  _m1__Array__set
	lw   $ra, -4($sp)
	li   $a0, 0
	sgt  $a0, $s0, $a0
	bnez $a0, L274
L265:
	lw   $s0, 8($sp)
	lw   $s1, 4($sp)
	lw   $s2, 0($sp)
	addi $sp, $sp, 16
	jr   $ra
L274:
	li   $a0, 1
	sub  $a1, $s0, $a0
	sw   $ra, -4($sp)
	move $a0, $s2
	jal  _p1__compute_row
	lw   $ra, -4($sp)
	b    L265
L314:
	li   $a2, 1
	b    L288
	.data
_s__0:
	.asciiz "0"
_s__1:
	.asciiz "*"
_s__2:
	.asciiz "\n"
_vt__Array__Array:

