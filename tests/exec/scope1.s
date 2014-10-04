	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m2__A__g:
	addi $sp, $sp, -4
	move $v0, $a1
	addi $v0, $v0, 1
	addi $sp, $sp, 4
	jr   $ra
_m1__A__f:
	addi $sp, $sp, -4
	li   $v0, 0
	addi $v0, $v0, 1
	addi $sp, $sp, 4
	jr   $ra
_m0__A__A:
	addi $sp, $sp, -4
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -12
	addi $t1, $sp, 0
	la   $t0, _vt__A__A
	sw   $t0, 0($t1)
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m0__A__A
	lw   $ra, -4($sp)
	li   $t0, 0
	sw   $t0, 4($sp)
	lw   $a0, 4($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m1__A__f
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	lw   $a0, 4($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	addi $a0, $sp, 0
	li   $a1, 1
	sw   $ra, -4($sp)
	jal  _m2__A__g
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__3
	li   $v0, 4
	syscall
	lw   $a0, 4($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__4
	li   $v0, 4
	syscall
	addi $sp, $sp, 12
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
_s__4:
	.asciiz "\n"
_vt__A__A:

