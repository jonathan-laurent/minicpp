	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m1__Puiss__pow:
	addi $sp, $sp, -4
	li   $v0, 1
	li   $t0, 0
L39:
	li   $t1, 2
	div  $t1, $a2, $t1
	slt  $t1, $t0, $t1
	bnez $t1, L33
	move $t0, $v0
	mul  $v0, $v0, $t0
	li   $t0, 2
	rem  $t1, $a2, $t0
	li   $t0, 0
	bne  $t1, $t0, L16
L12:
	addi $sp, $sp, 4
	jr   $ra
L16:
	mul  $v0, $v0, $a1
	b    L12
L33:
	mul  $v0, $v0, $a1
	addi $t0, $t0, 1
	b    L39
_m0__Puiss__Puiss:
	addi $sp, $sp, -4
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -8
	addi $t1, $sp, 0
	la   $t0, _vt__Puiss__Puiss
	sw   $t0, 0($t1)
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m0__Puiss__Puiss
	lw   $ra, -4($sp)
	addi $a0, $sp, 0
	li   $a1, 2
	li   $a2, 4
	sw   $ra, -4($sp)
	jal  _m1__Puiss__pow
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $a0, $sp, 0
	li   $a1, 6
	li   $a2, 3
	sw   $ra, -4($sp)
	jal  _m1__Puiss__pow
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	addi $sp, $sp, 8
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "\n"
_vt__Puiss__Puiss:

