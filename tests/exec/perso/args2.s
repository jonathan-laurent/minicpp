	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p1__test:
	addi $sp, $sp, -8
	sw   $a0, 0($sp)
	addi $t0, $sp, 0
	lw   $t2, 0($t0)
	li   $t1, 42
	add  $t1, $t2, $t1
	sw   $t1, 0($t0)
	lw   $v0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
_p0__main:
	addi $sp, $sp, -8
	sw   $s0, 0($sp)
	li   $s0, 0
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _p1__test
	lw   $ra, -4($sp)
	move $t0, $v0
	la   $a0, _s__1
	li   $v0, 4
	syscall
	move $a0, $s0
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	la   $a0, _s__3
	li   $v0, 4
	syscall
	move $a0, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	lw   $s0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "x = "
_s__2:
	.asciiz "\n"
_s__3:
	.asciiz "y = "

