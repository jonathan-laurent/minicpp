	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p2__plot:
	addi $sp, $sp, -4
	move $t1, $a0
L24:
	move $t0, $t1
	addi $t1, $t0, -1
	li   $t2, 0
	sgt  $t0, $t0, $t2
	bnez $t0, L17
	la   $a0, _s__1
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
L17:
	la   $a0, _s__0
	li   $v0, 4
	syscall
	b    L24
_p0__main:
	addi $sp, $sp, -4
	li   $a0, 10
	li   $a1, 6
	sw   $ra, -4($sp)
	jal  _p1__bresenham
	lw   $ra, -4($sp)
	addi $sp, $sp, 4
	jr   $ra
_p1__bresenham:
	addi $sp, $sp, -24
	sw   $s0, 16($sp)
	sw   $s1, 12($sp)
	sw   $s2, 8($sp)
	sw   $s3, 4($sp)
	sw   $s4, 0($sp)
	move $s3, $a0
	move $s2, $a1
	li   $s0, 0
	li   $s1, 0
	li   $t0, 2
	mul  $t0, $t0, $s2
	sub  $s4, $t0, $s3
	li   $s0, 0
L104:
	sle  $t0, $s0, $s3
	bnez $t0, L100
	lw   $s0, 16($sp)
	lw   $s1, 12($sp)
	lw   $s2, 8($sp)
	lw   $s3, 4($sp)
	lw   $s4, 0($sp)
	addi $sp, $sp, 24
	jr   $ra
L100:
	sw   $ra, -4($sp)
	move $a0, $s1
	jal  _p2__plot
	lw   $ra, -4($sp)
	li   $t0, 0
	slt  $t0, $s4, $t0
	bnez $t0, L91
	addi $s1, $s1, 1
	li   $t1, 2
	sub  $t0, $s2, $s3
	mul  $t0, $t1, $t0
	add  $s4, $s4, $t0
L74:
	addi $s0, $s0, 1
	b    L104
L91:
	li   $t0, 2
	mul  $t0, $t0, $s2
	add  $s4, $s4, $t0
	b    L74
	.data
_s__0:
	.asciiz " "
_s__1:
	.asciiz "X\n"

