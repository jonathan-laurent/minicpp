	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -8
	li   $t0, 41
	sw   $t0, 0($sp)
	la   $a0, _s__1
	li   $v0, 4
	syscall
	lw   $a0, 0($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $t0, $sp, 0
	li   $t1, 42
	sw   $t1, 0($t0)
	la   $a0, _s__3
	li   $v0, 4
	syscall
	lw   $a0, 0($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	lw   $t2, 0($t0)
	li   $t1, 1
	add  $t1, $t2, $t1
	sw   $t1, 0($t0)
	la   $a0, _s__5
	li   $v0, 4
	syscall
	lw   $a0, 0($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__4
	li   $v0, 4
	syscall
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
	.asciiz "x = "
_s__4:
	.asciiz "\n"
_s__5:
	.asciiz "x = "

