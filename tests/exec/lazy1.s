	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $t0, 42
	bnez $t0, L40
	li   $t1, 1
	li   $t0, 0
	div  $a0, $t1, $t0
L36:
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	li   $t0, 0
	bnez $t0, L29
	li   $a0, 0
L25:
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	li   $t0, 0
	li   $t1, 1
	bnez $t1, L13
	lw   $t0, 0($t0)
	bnez $t0, L13
L10:
	addi $sp, $sp, 4
	jr   $ra
L13:
	la   $a0, _s__2
	li   $v0, 4
	syscall
	b    L10
	b    L13
L29:
	li   $t1, 2
	li   $t0, 0
	div  $a0, $t1, $t0
	b    L25
L40:
	li   $a0, 1
	b    L36
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "\n"
_s__2:
	.asciiz "ok\n"

