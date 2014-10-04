	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m1__fib__next:
	addi $sp, $sp, -4
	lw   $v0, 4($a0)
	lw   $t1, 8($a0)
	lw   $t0, 4($a0)
	add  $t0, $t1, $t0
	sw   $t0, 4($a0)
	sw   $v0, 8($a0)
	addi $sp, $sp, 4
	jr   $ra
_m0__fib__fib:
	addi $sp, $sp, -4
	li   $t0, 1
	sw   $t0, 8($a0)
	li   $t0, 0
	sw   $t0, 4($a0)
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -16
	addi $t1, $sp, 0
	la   $t0, _vt__fib__fib
	sw   $t0, 0($t1)
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m0__fib__fib
	lw   $ra, -4($sp)
L89:
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m1__fib__next
	lw   $ra, -4($sp)
	move $t0, $v0
	li   $t1, 100
	sle  $t0, $t0, $t1
	bnez $t0, L78
	addi $sp, $sp, 16
	jr   $ra
L78:
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	b    L89
	.data
_s__0:
	.asciiz "\n"
_vt__fib__fib:

