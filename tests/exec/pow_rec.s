	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m1__Puiss__pow:
	addi $sp, $sp, -12
	sw   $s0, 4($sp)
	sw   $s1, 0($sp)
	move $s1, $a1
	move $s0, $a2
	li   $t0, 0
	sle  $t0, $s0, $t0
	bnez $t0, L40
	li   $t0, 2
	div  $a2, $s0, $t0
	sw   $ra, -4($sp)
	move $a1, $s1
	jal  _m1__Puiss__pow
	lw   $ra, -4($sp)
	move $t0, $v0
	mul  $v0, $v0, $t0
	li   $t0, 2
	rem  $t1, $s0, $t0
	li   $t0, 0
	beq  $t1, $t0, L16
	mul  $v0, $v0, $s1
L10:
	lw   $s0, 4($sp)
	lw   $s1, 0($sp)
	addi $sp, $sp, 12
	jr   $ra
L16:
	b    L10
L40:
	li   $v0, 1
	b    L10
_m0__Puiss__Puiss:
	addi $sp, $sp, -4
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -8
	addi $t1, $sp, 0
	la   $t0, _vt__Puiss__Puiss
	sw   $t0, 0($t1)
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m0__Puiss__Puiss
	lw   $ra, -4($sp)
	addi $a0, $sp, 0
	li   $a1, 2
	li   $a2, 4
	sw   $ra, -4($sp)
	jal  _m1__Puiss__pow
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $a0, $sp, 0
	li   $a1, 6
	li   $a2, 3
	sw   $ra, -4($sp)
	jal  _m1__Puiss__pow
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	addi $sp, $sp, 8
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "\n"
_vt__Puiss__Puiss:

