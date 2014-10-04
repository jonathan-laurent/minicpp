	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -16
	sw   $s0, 0($sp)
	li   $t0, 42
	sw   $t0, 8($sp)
	li   $t0, 43
	sw   $t0, 4($sp)
	li   $a0, 1
	addi $a1, $sp, 8
	addi $a2, $sp, 4
	sw   $ra, -4($sp)
	jal  _p1__f
	lw   $ra, -4($sp)
	li   $t0, 12
	sw   $t0, 0($v0)
	la   $a0, _s__5
	li   $v0, 4
	syscall
	lw   $a0, 8($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__4
	li   $v0, 4
	syscall
	la   $a0, _s__7
	li   $v0, 4
	syscall
	lw   $a0, 4($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__6
	li   $v0, 4
	syscall
	li   $s0, 13
	li   $a0, 0
	addi $a1, $sp, 8
	addi $a2, $sp, 4
	sw   $ra, -4($sp)
	jal  _p1__f
	lw   $ra, -4($sp)
	sw   $s0, 0($v0)
	la   $a0, _s__9
	li   $v0, 4
	syscall
	lw   $a0, 8($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__8
	li   $v0, 4
	syscall
	la   $a0, _s__11
	li   $v0, 4
	syscall
	lw   $a0, 4($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__10
	li   $v0, 4
	syscall
	lw   $s0, 0($sp)
	addi $sp, $sp, 16
	jr   $ra
_p1__f:
	addi $sp, $sp, -4
	move $t0, $a0
	la   $a0, _s__1
	li   $v0, 4
	syscall
	lw   $a0, 0($a1)
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	la   $a0, _s__3
	li   $v0, 4
	syscall
	lw   $a0, 0($a2)
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	bnez $t0, L99
	move $v0, $a2
L95:
	addi $sp, $sp, 4
	jr   $ra
L99:
	move $v0, $a1
	b    L95
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "x = "
_s__10:
	.asciiz "\n"
_s__11:
	.asciiz "y = "
_s__2:
	.asciiz "\n"
_s__3:
	.asciiz "y = "
_s__4:
	.asciiz "\n"
_s__5:
	.asciiz "x = "
_s__6:
	.asciiz "\n"
_s__7:
	.asciiz "y = "
_s__8:
	.asciiz "\n"
_s__9:
	.asciiz "x = "

