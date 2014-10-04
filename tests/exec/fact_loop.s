	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $a0, 5
	sw   $ra, -4($sp)
	jal  _p1__fact_loop
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_p1__fact_loop:
	addi $sp, $sp, -4
	li   $v0, 1
L54:
	li   $t0, 1
	sgt  $t0, $a0, $t0
	bnez $t0, L50
	addi $sp, $sp, 4
	jr   $ra
L50:
	move $t0, $a0
	addi $a0, $t0, -1
	mul  $v0, $v0, $t0
	b    L54
	.data
_s__0:
	.asciiz "\n"

