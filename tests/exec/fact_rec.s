	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $a0, 5
	sw   $ra, -4($sp)
	jal  _p1__fact_rec
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_p1__fact_rec:
	addi $sp, $sp, -8
	sw   $s0, 0($sp)
	move $s0, $a0
	li   $t0, 1
	sle  $t0, $s0, $t0
	bnez $t0, L53
	move $t0, $s0
	li   $t1, 1
	sub  $a0, $t0, $t1
	sw   $ra, -4($sp)
	jal  _p1__fact_rec
	lw   $ra, -4($sp)
	mul  $v0, $s0, $v0
L40:
	lw   $s0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
L53:
	li   $v0, 1
	b    L40
	.data
_s__0:
	.asciiz "\n"

