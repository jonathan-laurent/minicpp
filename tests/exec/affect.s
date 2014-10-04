	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $t1, 0
	li   $t0, 0
	addi $t1, $t0, 1
	move $t0, $t1
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	move $t2, $t1
	add  $t0, $t0, $t2
	addi $t0, $t0, 1
	addi $t1, $t1, -1
	add  $t1, $t1, $t0
	la   $a0, _s__1
	li   $v0, 4
	syscall
	move $a0, $t1
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
	addi $sp, $sp, 4
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "x="
_s__2:
	.asciiz "\n"
_s__3:
	.asciiz "y="

