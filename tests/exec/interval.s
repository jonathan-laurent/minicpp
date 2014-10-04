	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m3__interval__ok:
	addi $sp, $sp, -4
	lw   $t1, 0($a1)
	lw   $t0, 4($a0)
	sle  $v0, $t1, $t0
	addi $sp, $sp, 4
	jr   $ra
_m2__interval__next:
	addi $sp, $sp, -4
	lw   $v0, 0($a1)
	addi $t0, $v0, 1
	sw   $t0, 0($a1)
	addi $sp, $sp, 4
	jr   $ra
_m1__interval__iterate:
	addi $sp, $sp, -4
	lw   $t0, 8($a0)
	sw   $t0, 0($a1)
	addi $sp, $sp, 4
	jr   $ra
_m0__interval__interval:
	addi $sp, $sp, -4
	sw   $a1, 8($a0)
	sw   $a2, 4($a0)
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -20
	addi $t1, $sp, 0
	la   $t0, _vt__interval__interval
	sw   $t0, 0($t1)
	addi $a0, $sp, 0
	li   $a1, 3
	li   $a2, 10
	sw   $ra, -4($sp)
	jal  _m0__interval__interval
	lw   $ra, -4($sp)
	addi $a0, $sp, 0
	addi $a1, $sp, 12
	sw   $ra, -4($sp)
	jal  _m1__interval__iterate
	lw   $ra, -4($sp)
L141:
	addi $a0, $sp, 0
	addi $a1, $sp, 12
	sw   $ra, -4($sp)
	jal  _m3__interval__ok
	lw   $ra, -4($sp)
	bnez $v0, L132
	addi $sp, $sp, 20
	jr   $ra
L132:
	addi $a0, $sp, 0
	addi $a1, $sp, 12
	sw   $ra, -4($sp)
	jal  _m2__interval__next
	lw   $ra, -4($sp)
	move $a0, $v0
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	b    L141
	.data
_s__0:
	.asciiz "\n"
_vt__interval__interval:

