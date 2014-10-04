	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $t1, 41
	la   $t0, _g1__x
	sw   $t1, 0($t0)
	la   $t0, _g1__x
	lw   $a0, 0($t0)
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	la   $t1, _g1__x
	la   $t0, _g0__p
	sw   $t1, 0($t0)
	la   $t0, _g0__p
	lw   $t0, 0($t0)
	lw   $t1, 0($t0)
	li   $t0, 1
	add  $t1, $t1, $t0
	la   $t0, _g0__p
	lw   $t0, 0($t0)
	sw   $t1, 0($t0)
	la   $t0, _g1__x
	lw   $a0, 0($t0)
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	la   $t0, _g1__x
	lw   $t2, 0($t0)
	li   $t1, 1
	add  $t1, $t2, $t1
	sw   $t1, 0($t0)
	la   $t0, _g1__x
	lw   $a0, 0($t0)
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
	.data
_g1__x:
	.space 4
_g0__p:
	.space 4
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "\n"
_s__2:
	.asciiz "\n"

