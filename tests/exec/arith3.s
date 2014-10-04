	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $t0, 7
	neg  $t2, $t0
	li   $t1, 6
	li   $t0, 5
	mul  $t0, $t1, $t0
	add  $t2, $t2, $t0
	li   $t1, 4
	li   $t0, 3
	div  $t0, $t1, $t0
	sub  $t1, $t2, $t0
	li   $t0, 2
	sub  $t2, $t1, $t0
	move $a0, $t2
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	li   $t1, 7
	li   $t0, 6
	add  $t3, $t1, $t0
	li   $t1, 5
	li   $t0, 4
	sub  $t0, $t1, $t0
	mul  $t1, $t3, $t0
	li   $t0, 3
	div  $t1, $t1, $t0
	li   $t0, 2
	sub  $t1, $t1, $t0
	move $a0, $t1
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	li   $t7, 7
	li   $t6, 6
	li   $t5, 5
	li   $t4, 4
	li   $t3, 3
	li   $t0, 2
	sub  $t0, $t3, $t0
	div  $t0, $t4, $t0
	sub  $t0, $t5, $t0
	mul  $t0, $t6, $t0
	add  $t0, $t7, $t0
	move $a0, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	li   $t3, 8
	rem  $t2, $t2, $t3
	add  $t1, $t2, $t1
	add  $a0, $t1, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__3
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "\n"
_s__2:
	.asciiz "\n"
_s__3:
	.asciiz "\n"

