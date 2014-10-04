	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $t1, 1
	li   $t0, 2
	slt  $t0, $t1, $t0
	bnez $t0, L69
L64:
	li   $t1, 1
	li   $t0, 3
	add  $t2, $t1, $t0
	li   $t1, 4
	li   $t0, 0
	add  $t0, $t1, $t0
	seq  $a0, $t2, $t0
L57:
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	li   $t1, 2
	li   $t0, 1
	sgt  $t0, $t1, $t0
	bnez $t0, L48
	li   $a0, 0
L34:
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	li   $t0, 2
	neg  $t1, $t0
	li   $t0, 5
	neg  $t0, $t0
	mul  $t1, $t1, $t0
	li   $t0, 2
	beq  $t1, $t0, L22
L16:
	li   $a0, 0
L15:
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
L22:
	li   $t1, 1
	li   $t0, 2
	bne  $t1, $t0, L16
	li   $t1, 0
	li   $t0, 0
	seq  $a0, $t1, $t0
	b    L15
	b    L16
L48:
	li   $t1, 2
	li   $t0, 3
	sge  $t0, $t1, $t0
	bnez $t0, L44
	li   $t1, 3
	li   $t0, 3
	sne  $t2, $t1, $t0
L40:
	li   $t1, 3
	li   $t0, 4
	seq  $t0, $t1, $t0
	seq  $t0, $t0, $0
	seq  $a0, $t2, $t0
	b    L34
L44:
	li   $t2, 1
	b    L40
L69:
	li   $t1, 2
	li   $t0, 3
	sle  $t0, $t1, $t0
	beqz $t0, L64
	li   $a0, 1
	b    L57
	b    L64
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "\n"
_s__2:
	.asciiz "\n"

