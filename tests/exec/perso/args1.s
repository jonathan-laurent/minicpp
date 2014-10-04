	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $a0, 1
	li   $a1, 2
	li   $a2, 3
	li   $a3, 4
	li   $t1, 5
	li   $t0, 6
	sw   $ra, -4($sp)
	sw   $t1, -8($sp)
	sw   $t0, -12($sp)
	jal  _p1__f
	lw   $ra, -4($sp)
	move $t0, $v0
	la   $a0, _s__8
	li   $v0, 4
	syscall
	move $a0, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__7
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_p1__f:
	addi $sp, $sp, -12
	move $t0, $a0
	la   $a0, _s__6
	li   $v0, 4
	syscall
	move $a0, $t0
	li   $v0, 1
	syscall
	la   $a0, _s__5
	li   $v0, 4
	syscall
	move $a0, $a1
	li   $v0, 1
	syscall
	la   $a0, _s__4
	li   $v0, 4
	syscall
	move $a0, $a2
	li   $v0, 1
	syscall
	la   $a0, _s__3
	li   $v0, 4
	syscall
	move $a0, $a3
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	lw   $a0, 4($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	lw   $a0, 0($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	add  $t0, $t0, $a1
	add  $t0, $t0, $a2
	add  $t1, $t0, $a3
	lw   $t0, 4($sp)
	add  $t1, $t1, $t0
	lw   $t0, 0($sp)
	add  $v0, $t1, $t0
	addi $sp, $sp, 12
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz ", f = "
_s__2:
	.asciiz ", e = "
_s__3:
	.asciiz ", d = "
_s__4:
	.asciiz ", c = "
_s__5:
	.asciiz ", b = "
_s__6:
	.asciiz "a = "
_s__7:
	.asciiz "\n"
_s__8:
	.asciiz "x = "

