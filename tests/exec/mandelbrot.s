	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p7__sub:
	addi $sp, $sp, -4
	sub  $v0, $a0, $a1
	addi $sp, $sp, 4
	jr   $ra
_p4__of_int:
	addi $sp, $sp, -4
	li   $t0, 8192
	mul  $v0, $a0, $t0
	addi $sp, $sp, 4
	jr   $ra
_p6__mul:
	addi $sp, $sp, -4
	mul  $t0, $a0, $a1
	li   $t2, 8192
	li   $t1, 2
	div  $t1, $t2, $t1
	add  $t1, $t0, $t1
	li   $t0, 8192
	div  $v0, $t1, $t0
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -36
	sw   $s0, 28($sp)
	sw   $s1, 24($sp)
	sw   $s2, 20($sp)
	sw   $s3, 16($sp)
	sw   $s4, 12($sp)
	sw   $s5, 8($sp)
	sw   $s6, 4($sp)
	sw   $s7, 0($sp)
	li   $s6, 30
	li   $t0, 2
	neg  $a0, $t0
	sw   $ra, -4($sp)
	jal  _p4__of_int
	lw   $ra, -4($sp)
	move $s7, $v0
	li   $a0, 1
	sw   $ra, -4($sp)
	jal  _p4__of_int
	lw   $ra, -4($sp)
	sw   $ra, -4($sp)
	move $a0, $v0
	move $a1, $s7
	jal  _p7__sub
	lw   $ra, -4($sp)
	move $s0, $v0
	li   $t0, 2
	mul  $a0, $t0, $s6
	sw   $ra, -4($sp)
	jal  _p4__of_int
	lw   $ra, -4($sp)
	sw   $ra, -4($sp)
	move $a0, $s0
	move $a1, $v0
	jal  _p2__div
	lw   $ra, -4($sp)
	move $s4, $v0
	li   $t0, 1
	neg  $a0, $t0
	sw   $ra, -4($sp)
	jal  _p4__of_int
	lw   $ra, -4($sp)
	move $s5, $v0
	li   $a0, 1
	sw   $ra, -4($sp)
	jal  _p4__of_int
	lw   $ra, -4($sp)
	sw   $ra, -4($sp)
	move $a0, $v0
	move $a1, $s5
	jal  _p7__sub
	lw   $ra, -4($sp)
	move $s0, $v0
	sw   $ra, -4($sp)
	move $a0, $s6
	jal  _p4__of_int
	lw   $ra, -4($sp)
	sw   $ra, -4($sp)
	move $a0, $s0
	move $a1, $v0
	jal  _p2__div
	lw   $ra, -4($sp)
	move $s0, $v0
	li   $s1, 0
L172:
	slt  $t0, $s1, $s6
	bnez $t0, L168
	lw   $s0, 28($sp)
	lw   $s1, 24($sp)
	lw   $s2, 20($sp)
	lw   $s3, 16($sp)
	lw   $s4, 12($sp)
	lw   $s5, 8($sp)
	lw   $s6, 4($sp)
	lw   $s7, 0($sp)
	addi $sp, $sp, 36
	jr   $ra
L168:
	sw   $ra, -4($sp)
	move $a0, $s1
	jal  _p4__of_int
	lw   $ra, -4($sp)
	sw   $ra, -4($sp)
	move $a0, $v0
	move $a1, $s0
	jal  _p6__mul
	lw   $ra, -4($sp)
	sw   $ra, -4($sp)
	move $a0, $s5
	move $a1, $v0
	jal  _p1__add
	lw   $ra, -4($sp)
	move $s2, $v0
	li   $s3, 0
L145:
	li   $t0, 2
	mul  $t0, $t0, $s6
	slt  $t0, $s3, $t0
	bnez $t0, L139
	la   $a0, _s__2
	li   $v0, 4
	syscall
	addi $s1, $s1, 1
	b    L172
L139:
	sw   $ra, -4($sp)
	move $a0, $s3
	jal  _p4__of_int
	lw   $ra, -4($sp)
	sw   $ra, -4($sp)
	move $a0, $v0
	move $a1, $s4
	jal  _p6__mul
	lw   $ra, -4($sp)
	sw   $ra, -4($sp)
	move $a0, $s7
	move $a1, $v0
	jal  _p1__add
	lw   $ra, -4($sp)
	sw   $ra, -4($sp)
	move $a0, $v0
	move $a1, $s2
	jal  _p3__inside
	lw   $ra, -4($sp)
	bnez $v0, L109
	la   $a0, _s__0
	li   $v0, 4
	syscall
L103:
	addi $s3, $s3, 1
	b    L145
L109:
	la   $a0, _s__1
	li   $v0, 4
	syscall
	b    L103
_p5__iter:
	addi $sp, $sp, -40
	sw   $s0, 28($sp)
	sw   $s1, 24($sp)
	sw   $s2, 20($sp)
	sw   $s3, 16($sp)
	sw   $s4, 12($sp)
	sw   $s5, 8($sp)
	sw   $s6, 4($sp)
	sw   $s7, 0($sp)
	move $s0, $a0
	move $s2, $a1
	move $s7, $a2
	move $s6, $a3
	li   $t0, 100
	beq  $s0, $t0, L364
	move $t0, $s6
	sw   $ra, -4($sp)
	move $a0, $t0
	move $a1, $s6
	jal  _p6__mul
	lw   $ra, -4($sp)
	move $s3, $v0
	lw   $a0, 32($sp)
	lw   $a1, 32($sp)
	sw   $ra, -4($sp)
	jal  _p6__mul
	lw   $ra, -4($sp)
	move $s4, $v0
	sw   $ra, -4($sp)
	move $a0, $s3
	move $a1, $s4
	jal  _p1__add
	lw   $ra, -4($sp)
	move $s1, $v0
	li   $a0, 4
	sw   $ra, -4($sp)
	jal  _p4__of_int
	lw   $ra, -4($sp)
	sgt  $t0, $s1, $v0
	bnez $t0, L328
	li   $t0, 1
	add  $s5, $s0, $t0
	sw   $ra, -4($sp)
	move $a0, $s3
	move $a1, $s4
	jal  _p7__sub
	lw   $ra, -4($sp)
	move $t0, $s2
	sw   $ra, -4($sp)
	move $a0, $v0
	move $a1, $t0
	jal  _p1__add
	lw   $ra, -4($sp)
	move $s1, $v0
	li   $a0, 2
	sw   $ra, -4($sp)
	jal  _p4__of_int
	lw   $ra, -4($sp)
	move $s0, $v0
	lw   $a1, 32($sp)
	sw   $ra, -4($sp)
	move $a0, $s6
	jal  _p6__mul
	lw   $ra, -4($sp)
	sw   $ra, -4($sp)
	move $a0, $s0
	move $a1, $v0
	jal  _p6__mul
	lw   $ra, -4($sp)
	move $t0, $s7
	sw   $ra, -4($sp)
	move $a0, $v0
	move $a1, $t0
	jal  _p1__add
	lw   $ra, -4($sp)
	sw   $ra, -4($sp)
	move $a0, $s5
	move $a1, $s2
	move $a2, $s7
	move $a3, $s1
	sw   $v0, -8($sp)
	jal  _p5__iter
	lw   $ra, -4($sp)
L269:
	lw   $s0, 28($sp)
	lw   $s1, 24($sp)
	lw   $s2, 20($sp)
	lw   $s3, 16($sp)
	lw   $s4, 12($sp)
	lw   $s5, 8($sp)
	lw   $s6, 4($sp)
	lw   $s7, 0($sp)
	addi $sp, $sp, 40
	jr   $ra
L328:
	li   $v0, 0
	b    L269
L364:
	li   $v0, 1
	b    L269
_p3__inside:
	addi $sp, $sp, -20
	sw   $s0, 12($sp)
	sw   $s1, 8($sp)
	sw   $s2, 4($sp)
	sw   $s3, 0($sp)
	move $s3, $a0
	move $s2, $a1
	li   $s1, 0
	li   $a0, 0
	sw   $ra, -4($sp)
	jal  _p4__of_int
	lw   $ra, -4($sp)
	move $s0, $v0
	li   $a0, 0
	sw   $ra, -4($sp)
	jal  _p4__of_int
	lw   $ra, -4($sp)
	sw   $ra, -4($sp)
	move $a0, $s1
	move $a1, $s3
	move $a2, $s2
	move $a3, $s0
	sw   $v0, -8($sp)
	jal  _p5__iter
	lw   $ra, -4($sp)
	lw   $s0, 12($sp)
	lw   $s1, 8($sp)
	lw   $s2, 4($sp)
	lw   $s3, 0($sp)
	addi $sp, $sp, 20
	jr   $ra
_p2__div:
	addi $sp, $sp, -4
	li   $t0, 8192
	mul  $t0, $a0, $t0
	li   $t1, 2
	div  $t1, $a1, $t1
	add  $t0, $t0, $t1
	div  $v0, $t0, $a1
	addi $sp, $sp, 4
	jr   $ra
_p1__add:
	addi $sp, $sp, -4
	add  $v0, $a0, $a1
	addi $sp, $sp, 4
	jr   $ra
	.data
_s__0:
	.asciiz "1"
_s__1:
	.asciiz "0"
_s__2:
	.asciiz "\n"

