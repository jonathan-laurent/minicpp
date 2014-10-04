	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -16
	sw   $s0, 4($sp)
	sw   $s1, 0($sp)
	li   $t0, 41
	sw   $t0, 8($sp)
	la   $a0, _s__1
	li   $v0, 4
	syscall
	lw   $a0, 8($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $a0, $sp, 8
	sw   $ra, -4($sp)
	jal  _p1__f
	lw   $ra, -4($sp)
	la   $a0, _s__3
	li   $v0, 4
	syscall
	lw   $a0, 8($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	addi $s0, $sp, 8
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _p1__f
	lw   $ra, -4($sp)
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
	lw   $a0, 0($s0)
	li   $v0, 1
	syscall
	la   $a0, _s__6
	li   $v0, 4
	syscall
	move $s1, $s0
	sw   $ra, -4($sp)
	move $a0, $s1
	jal  _p1__f
	lw   $ra, -4($sp)
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
	lw   $a0, 0($s0)
	li   $v0, 1
	syscall
	la   $a0, _s__10
	li   $v0, 4
	syscall
	la   $a0, _s__13
	li   $v0, 4
	syscall
	lw   $a0, 0($s1)
	li   $v0, 1
	syscall
	la   $a0, _s__12
	li   $v0, 4
	syscall
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _p1__f
	lw   $ra, -4($sp)
	la   $a0, _s__15
	li   $v0, 4
	syscall
	lw   $a0, 8($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__14
	li   $v0, 4
	syscall
	la   $a0, _s__17
	li   $v0, 4
	syscall
	lw   $a0, 0($s0)
	li   $v0, 1
	syscall
	la   $a0, _s__16
	li   $v0, 4
	syscall
	la   $a0, _s__19
	li   $v0, 4
	syscall
	lw   $a0, 0($s1)
	li   $v0, 1
	syscall
	la   $a0, _s__18
	li   $v0, 4
	syscall
	addi $a0, $sp, 8
	sw   $ra, -4($sp)
	jal  _p1__f
	lw   $ra, -4($sp)
	la   $a0, _s__21
	li   $v0, 4
	syscall
	lw   $a0, 8($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__20
	li   $v0, 4
	syscall
	la   $a0, _s__23
	li   $v0, 4
	syscall
	lw   $a0, 0($s0)
	li   $v0, 1
	syscall
	la   $a0, _s__22
	li   $v0, 4
	syscall
	la   $a0, _s__25
	li   $v0, 4
	syscall
	lw   $a0, 0($s1)
	li   $v0, 1
	syscall
	la   $a0, _s__24
	li   $v0, 4
	syscall
	lw   $s0, 4($sp)
	lw   $s1, 0($sp)
	addi $sp, $sp, 16
	jr   $ra
_p1__f:
	addi $sp, $sp, -4
	lw   $t1, 0($a0)
	li   $t0, 1
	add  $t0, $t1, $t0
	sw   $t0, 0($a0)
	addi $sp, $sp, 4
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "x = "
_s__10:
	.asciiz "\n"
_s__11:
	.asciiz "z = "
_s__12:
	.asciiz "\n"
_s__13:
	.asciiz "u = "
_s__14:
	.asciiz "\n"
_s__15:
	.asciiz "x = "
_s__16:
	.asciiz "\n"
_s__17:
	.asciiz "z = "
_s__18:
	.asciiz "\n"
_s__19:
	.asciiz "u = "
_s__2:
	.asciiz "\n"
_s__20:
	.asciiz "\n"
_s__21:
	.asciiz "x = "
_s__22:
	.asciiz "\n"
_s__23:
	.asciiz "z = "
_s__24:
	.asciiz "\n"
_s__25:
	.asciiz "u = "
_s__3:
	.asciiz "x = "
_s__4:
	.asciiz "\n"
_s__5:
	.asciiz "x = "
_s__6:
	.asciiz "\n"
_s__7:
	.asciiz "z = "
_s__8:
	.asciiz "\n"
_s__9:
	.asciiz "x = "

