	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m4__Node__Node:
	addi $sp, $sp, -4
	sw   $a1, 8($a0)
	sw   $a2, 4($a0)
	sw   $a3, 12($a0)
	addi $sp, $sp, 4
	jr   $ra
_m5__BST__size:
	addi $sp, $sp, -4
	lw   $a0, 4($a0)
	sw   $ra, -4($sp)
	jal  _p4__tree_size
	lw   $ra, -4($sp)
	addi $sp, $sp, 4
	jr   $ra
_m3__BST__print:
	addi $sp, $sp, -4
	lw   $a0, 4($a0)
	sw   $ra, -4($sp)
	jal  _p3__tree_print
	lw   $ra, -4($sp)
	la   $a0, _s__2
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
_m2__BST__add2:
	addi $sp, $sp, -4
	addi $a0, $a0, 4
	sw   $ra, -4($sp)
	jal  _p2__tree_add_ref
	lw   $ra, -4($sp)
	addi $sp, $sp, 4
	jr   $ra
_m1__BST__add1:
	addi $sp, $sp, -8
	sw   $s0, 0($sp)
	move $s0, $a0
	lw   $a0, 4($s0)
	sw   $ra, -4($sp)
	jal  _p1__tree_add
	lw   $ra, -4($sp)
	sw   $v0, 4($s0)
	lw   $s0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
_m0__BST__BST:
	addi $sp, $sp, -4
	li   $t0, 0
	sw   $t0, 4($a0)
	addi $sp, $sp, 4
	jr   $ra
_p4__tree_size:
	addi $sp, $sp, -12
	sw   $s0, 4($sp)
	sw   $s1, 0($sp)
	move $s1, $a0
	li   $t0, 0
	beq  $s1, $t0, L203
	li   $s0, 1
	lw   $a0, 8($s1)
	sw   $ra, -4($sp)
	jal  _p4__tree_size
	lw   $ra, -4($sp)
	add  $s0, $s0, $v0
	lw   $a0, 12($s1)
	sw   $ra, -4($sp)
	jal  _p4__tree_size
	lw   $ra, -4($sp)
	add  $v0, $s0, $v0
L183:
	lw   $s0, 4($sp)
	lw   $s1, 0($sp)
	addi $sp, $sp, 12
	jr   $ra
L203:
	li   $v0, 0
	b    L183
_p3__tree_print:
	addi $sp, $sp, -8
	sw   $s0, 0($sp)
	move $s0, $a0
	li   $t0, 0
	beq  $s0, $t0, L249
	la   $a0, _s__0
	li   $v0, 4
	syscall
	lw   $a0, 8($s0)
	sw   $ra, -4($sp)
	jal  _p3__tree_print
	lw   $ra, -4($sp)
	lw   $a0, 4($s0)
	li   $v0, 1
	syscall
	lw   $a0, 12($s0)
	sw   $ra, -4($sp)
	jal  _p3__tree_print
	lw   $ra, -4($sp)
	la   $a0, _s__1
	li   $v0, 4
	syscall
L226:
	lw   $s0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
L249:
	b    L226
_p2__tree_add_ref:
	addi $sp, $sp, -12
	sw   $s0, 4($sp)
	sw   $s1, 0($sp)
	move $s0, $a0
	move $a2, $a1
	lw   $t1, 0($s0)
	li   $t0, 0
	beq  $t1, $t0, L320
	lw   $t0, 0($s0)
	lw   $t0, 4($t0)
	slt  $t0, $a2, $t0
	bnez $t0, L296
	lw   $t0, 0($s0)
	lw   $t0, 4($t0)
	sgt  $t0, $a2, $t0
	bnez $t0, L281
L272:
	lw   $s0, 4($sp)
	lw   $s1, 0($sp)
	addi $sp, $sp, 12
	jr   $ra
L281:
	lw   $a0, 0($s0)
	addi $a0, $a0, 12
	sw   $ra, -4($sp)
	move $a1, $a2
	jal  _p2__tree_add_ref
	lw   $ra, -4($sp)
	b    L272
L296:
	lw   $a0, 0($s0)
	addi $a0, $a0, 8
	sw   $ra, -4($sp)
	move $a1, $a2
	jal  _p2__tree_add_ref
	lw   $ra, -4($sp)
	b    L272
L320:
	li   $a0, 16
	li   $v0, 9
	syscall
	move $s1, $v0
	la   $t0, _vt__Node__Node
	sw   $t0, 0($s1)
	li   $a1, 0
	li   $a3, 0
	sw   $ra, -4($sp)
	move $a0, $s1
	jal  _m4__Node__Node
	lw   $ra, -4($sp)
	sw   $s1, 0($s0)
	b    L272
_p1__tree_add:
	addi $sp, $sp, -8
	sw   $s0, 0($sp)
	move $s0, $a0
	move $a2, $a1
	li   $t0, 0
	beq  $s0, $t0, L396
	lw   $t0, 4($s0)
	slt  $t0, $a2, $t0
	bnez $t0, L374
	lw   $t0, 4($s0)
	sgt  $t0, $a2, $t0
	bnez $t0, L358
L347:
	move $v0, $s0
L345:
	lw   $s0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
L358:
	lw   $a0, 12($s0)
	sw   $ra, -4($sp)
	move $a1, $a2
	jal  _p1__tree_add
	lw   $ra, -4($sp)
	sw   $v0, 12($s0)
	b    L347
L374:
	lw   $a0, 8($s0)
	sw   $ra, -4($sp)
	move $a1, $a2
	jal  _p1__tree_add
	lw   $ra, -4($sp)
	sw   $v0, 8($s0)
	b    L347
L396:
	li   $a0, 16
	li   $v0, 9
	syscall
	la   $t0, _vt__Node__Node
	sw   $t0, 0($v0)
	li   $a1, 0
	li   $a3, 0
	sw   $ra, -4($sp)
	move $a0, $v0
	jal  _m4__Node__Node
	lw   $ra, -4($sp)
	b    L345
_p0__main:
	addi $sp, $sp, -20
	sw   $s0, 4($sp)
	sw   $s1, 0($sp)
	addi $t1, $sp, 8
	la   $t0, _vt__BST__BST
	sw   $t0, 0($t1)
	addi $a0, $sp, 8
	sw   $ra, -4($sp)
	jal  _m0__BST__BST
	lw   $ra, -4($sp)
	addi $a0, $sp, 8
	li   $a1, 2
	sw   $ra, -4($sp)
	jal  _m1__BST__add1
	lw   $ra, -4($sp)
	addi $a0, $sp, 8
	li   $a1, 3
	sw   $ra, -4($sp)
	jal  _m2__BST__add2
	lw   $ra, -4($sp)
	addi $a0, $sp, 8
	li   $a1, 1
	sw   $ra, -4($sp)
	jal  _m1__BST__add1
	lw   $ra, -4($sp)
	addi $a0, $sp, 8
	sw   $ra, -4($sp)
	jal  _m3__BST__print
	lw   $ra, -4($sp)
	addi $a0, $sp, 8
	li   $a1, 7
	sw   $ra, -4($sp)
	jal  _m2__BST__add2
	lw   $ra, -4($sp)
	addi $a0, $sp, 8
	li   $a1, 0
	sw   $ra, -4($sp)
	jal  _m1__BST__add1
	lw   $ra, -4($sp)
	addi $a0, $sp, 8
	sw   $ra, -4($sp)
	jal  _m3__BST__print
	lw   $ra, -4($sp)
	li   $a0, 8
	li   $v0, 9
	syscall
	move $s0, $v0
	la   $t0, _vt__BST__BST
	sw   $t0, 0($s0)
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m0__BST__BST
	lw   $ra, -4($sp)
	li   $s1, 0
L472:
	li   $t0, 10
	slt  $t0, $s1, $t0
	bnez $t0, L468
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m3__BST__print
	lw   $ra, -4($sp)
	li   $s1, 0
L446:
	li   $t0, 10
	slt  $t0, $s1, $t0
	bnez $t0, L442
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m3__BST__print
	lw   $ra, -4($sp)
	li   $v0, 0
	lw   $s0, 4($sp)
	lw   $s1, 0($sp)
	addi $sp, $sp, 20
	jr   $ra
L442:
	li   $t0, 29
	mul  $t1, $t0, $s1
	li   $t0, 13
	rem  $a1, $t1, $t0
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m2__BST__add2
	lw   $ra, -4($sp)
	addi $s1, $s1, 1
	b    L446
L468:
	li   $t0, 31
	mul  $t1, $t0, $s1
	li   $t0, 7
	rem  $a1, $t1, $t0
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m1__BST__add1
	lw   $ra, -4($sp)
	addi $s1, $s1, 1
	b    L472
	.data
_s__0:
	.asciiz "("
_s__1:
	.asciiz ")"
_s__2:
	.asciiz "\n"
_vt__BST__BST:
_vt__Node__Node:

