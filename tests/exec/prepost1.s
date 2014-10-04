	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $t0, 41
	la   $a0, _s__1
	li   $v0, 4
	syscall
	move $a0, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $t0, $t0, 1
	la   $a0, _s__3
	li   $v0, 4
	syscall
	move $a0, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	addi $t0, $t0, -1
	la   $a0, _s__5
	li   $v0, 4
	syscall
	move $a0, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__4
	li   $v0, 4
	syscall
	addi $t0, $t0, 1
	la   $a0, _s__7
	li   $v0, 4
	syscall
	move $a0, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__6
	li   $v0, 4
	syscall
	addi $t0, $t0, -1
	la   $a0, _s__9
	li   $v0, 4
	syscall
	move $a0, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__8
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "x = "
_s__2:
	.asciiz "\n"
_s__3:
	.asciiz "x = "
_s__4:
	.asciiz "\n"
_s__5:
	.asciiz "x = "
_s__6:
	.asciiz "\n"
_s__7:
	.asciiz "x = "
_s__8:
	.asciiz "\n"
_s__9:
	.asciiz "x = "

