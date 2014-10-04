	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m1__list__get:
	addi $sp, $sp, -84
	sw   $s0, 76($sp)
	sw   $s1, 72($sp)
	sw   $s2, 68($sp)
	sw   $s3, 64($sp)
	sw   $s4, 60($sp)
	sw   $s5, 56($sp)
	sw   $s6, 52($sp)
	sw   $s7, 48($sp)
	sw   $a0, 44($sp)
	sw   $a1, 40($sp)
	lw   $v1, 44($sp)
	sw   $v1, 0($sp)
	lw   $v1, 0($sp)
	lw   $v1, 4($v1)
	sw   $v1, 4($sp)
	lw   $v1, 4($sp)
	sw   $v1, 36($sp)
L24:
	lw   $v1, 40($sp)
	sw   $v1, 12($sp)
	lw   $v1, 12($sp)
	addi $v1, $v1, -1
	sw   $v1, 8($sp)
	lw   $v1, 8($sp)
	sw   $v1, 40($sp)
	lw   $v1, 12($sp)
	sw   $v1, 20($sp)
	li   $v1, 0
	sw   $v1, 16($sp)
	lw   $v1, 20($sp)
	lw   $fp, 16($sp)
	sgt  $v1, $v1, $fp
	sw   $v1, 24($sp)
	lw   $v1, 24($sp)
	bnez $v1, L17
	lw   $v0, 36($sp)
	addi $v0, $v0, 8
	lw   $s0, 76($sp)
	lw   $s1, 72($sp)
	lw   $s2, 68($sp)
	lw   $s3, 64($sp)
	lw   $s4, 60($sp)
	lw   $s5, 56($sp)
	lw   $s6, 52($sp)
	lw   $s7, 48($sp)
	addi $sp, $sp, 84
	jr   $ra
L17:
	lw   $v1, 36($sp)
	sw   $v1, 28($sp)
	lw   $v1, 28($sp)
	lw   $v1, 4($v1)
	sw   $v1, 32($sp)
	lw   $v1, 32($sp)
	sw   $v1, 36($sp)
	b    L24
_m0__list__list:
	addi $sp, $sp, -96
	sw   $s0, 88($sp)
	sw   $s1, 84($sp)
	sw   $s2, 80($sp)
	sw   $s3, 76($sp)
	sw   $s4, 72($sp)
	sw   $s5, 68($sp)
	sw   $s6, 64($sp)
	sw   $s7, 60($sp)
	sw   $a0, 56($sp)
	sw   $a1, 52($sp)
	li   $v1, 0
	sw   $v1, 4($sp)
	lw   $v1, 56($sp)
	sw   $v1, 0($sp)
	lw   $v1, 4($sp)
	lw   $fp, 0($sp)
	sw   $v1, 4($fp)
L73:
	lw   $v1, 52($sp)
	sw   $v1, 12($sp)
	lw   $v1, 12($sp)
	addi $v1, $v1, -1
	sw   $v1, 8($sp)
	lw   $v1, 8($sp)
	sw   $v1, 52($sp)
	lw   $v1, 12($sp)
	sw   $v1, 20($sp)
	li   $v1, 0
	sw   $v1, 16($sp)
	lw   $v1, 20($sp)
	lw   $fp, 16($sp)
	sgt  $v1, $v1, $fp
	sw   $v1, 24($sp)
	lw   $v1, 24($sp)
	bnez $v1, L66
	lw   $s0, 88($sp)
	lw   $s1, 84($sp)
	lw   $s2, 80($sp)
	lw   $s3, 76($sp)
	lw   $s4, 72($sp)
	lw   $s5, 68($sp)
	lw   $s6, 64($sp)
	lw   $s7, 60($sp)
	addi $sp, $sp, 96
	jr   $ra
L66:
	li   $a0, 12
	li   $v0, 9
	syscall
	sw   $v0, 48($sp)
	la   $v1, _vt__cell__cell
	sw   $v1, 28($sp)
	lw   $v1, 28($sp)
	lw   $fp, 48($sp)
	sw   $v1, 0($fp)
	li   $v1, 0
	sw   $v1, 40($sp)
	lw   $v1, 56($sp)
	sw   $v1, 32($sp)
	lw   $v1, 32($sp)
	lw   $v1, 4($v1)
	sw   $v1, 36($sp)
	sw   $ra, -4($sp)
	lw   $a0, 48($sp)
	lw   $a1, 40($sp)
	lw   $a2, 36($sp)
	jal  _m2__cell__cell
	lw   $ra, -4($sp)
	lw   $v1, 56($sp)
	sw   $v1, 44($sp)
	lw   $v1, 48($sp)
	lw   $fp, 44($sp)
	sw   $v1, 4($fp)
	b    L73
_m2__cell__cell:
	addi $sp, $sp, -64
	sw   $s0, 56($sp)
	sw   $s1, 52($sp)
	sw   $s2, 48($sp)
	sw   $s3, 44($sp)
	sw   $s4, 40($sp)
	sw   $s5, 36($sp)
	sw   $s6, 32($sp)
	sw   $s7, 28($sp)
	sw   $a0, 24($sp)
	sw   $a1, 20($sp)
	sw   $a2, 16($sp)
	lw   $v1, 20($sp)
	sw   $v1, 4($sp)
	lw   $v1, 24($sp)
	sw   $v1, 0($sp)
	lw   $v1, 4($sp)
	lw   $fp, 0($sp)
	sw   $v1, 8($fp)
	lw   $v1, 16($sp)
	sw   $v1, 12($sp)
	lw   $v1, 24($sp)
	sw   $v1, 8($sp)
	lw   $v1, 12($sp)
	lw   $fp, 8($sp)
	sw   $v1, 4($fp)
	lw   $s0, 56($sp)
	lw   $s1, 52($sp)
	lw   $s2, 48($sp)
	lw   $s3, 44($sp)
	lw   $s4, 40($sp)
	lw   $s5, 36($sp)
	lw   $s6, 32($sp)
	lw   $s7, 28($sp)
	addi $sp, $sp, 64
	jr   $ra
_p0__main:
	addi $sp, $sp, -180
	sw   $s0, 164($sp)
	sw   $s1, 160($sp)
	sw   $s2, 156($sp)
	sw   $s3, 152($sp)
	sw   $s4, 148($sp)
	sw   $s5, 144($sp)
	sw   $s6, 140($sp)
	sw   $s7, 136($sp)
	addi $v1, $sp, 168
	sw   $v1, 4($sp)
	la   $v1, _vt__list__list
	sw   $v1, 0($sp)
	lw   $v1, 0($sp)
	lw   $fp, 4($sp)
	sw   $v1, 0($fp)
	addi $v1, $sp, 168
	sw   $v1, 12($sp)
	li   $v1, 11
	sw   $v1, 8($sp)
	sw   $ra, -4($sp)
	lw   $a0, 12($sp)
	lw   $a1, 8($sp)
	jal  _m0__list__list
	lw   $ra, -4($sp)
	li   $v1, 1
	sw   $v1, 28($sp)
	addi $v1, $sp, 168
	sw   $v1, 20($sp)
	li   $v1, 1
	sw   $v1, 16($sp)
	sw   $ra, -4($sp)
	lw   $a0, 20($sp)
	lw   $a1, 16($sp)
	jal  _m1__list__get
	lw   $ra, -4($sp)
	sw   $v0, 24($sp)
	lw   $v1, 28($sp)
	lw   $fp, 24($sp)
	sw   $v1, 0($fp)
	li   $v1, 2
	sw   $v1, 32($sp)
	lw   $v1, 32($sp)
	sw   $v1, 132($sp)
L188:
	lw   $v1, 132($sp)
	sw   $v1, 40($sp)
	li   $v1, 11
	sw   $v1, 36($sp)
	lw   $v1, 40($sp)
	lw   $fp, 36($sp)
	slt  $v1, $v1, $fp
	sw   $v1, 44($sp)
	lw   $v1, 44($sp)
	bnez $v1, L184
	lw   $s0, 164($sp)
	lw   $s1, 160($sp)
	lw   $s2, 156($sp)
	lw   $s3, 152($sp)
	lw   $s4, 148($sp)
	lw   $s5, 144($sp)
	lw   $s6, 140($sp)
	lw   $s7, 136($sp)
	addi $sp, $sp, 180
	jr   $ra
L184:
	addi $v1, $sp, 168
	sw   $v1, 60($sp)
	lw   $v1, 132($sp)
	sw   $v1, 52($sp)
	li   $v1, 2
	sw   $v1, 48($sp)
	lw   $v1, 52($sp)
	lw   $fp, 48($sp)
	sub  $v1, $v1, $fp
	sw   $v1, 56($sp)
	sw   $ra, -4($sp)
	lw   $a0, 60($sp)
	lw   $a1, 56($sp)
	jal  _m1__list__get
	lw   $ra, -4($sp)
	sw   $v0, 64($sp)
	lw   $v1, 64($sp)
	lw   $v1, 0($v1)
	sw   $v1, 92($sp)
	addi $v1, $sp, 168
	sw   $v1, 80($sp)
	lw   $v1, 132($sp)
	sw   $v1, 72($sp)
	li   $v1, 1
	sw   $v1, 68($sp)
	lw   $v1, 72($sp)
	lw   $fp, 68($sp)
	sub  $v1, $v1, $fp
	sw   $v1, 76($sp)
	sw   $ra, -4($sp)
	lw   $a0, 80($sp)
	lw   $a1, 76($sp)
	jal  _m1__list__get
	lw   $ra, -4($sp)
	sw   $v0, 84($sp)
	lw   $v1, 84($sp)
	lw   $v1, 0($v1)
	sw   $v1, 88($sp)
	lw   $v1, 92($sp)
	lw   $fp, 88($sp)
	add  $v1, $v1, $fp
	sw   $v1, 108($sp)
	addi $v1, $sp, 168
	sw   $v1, 100($sp)
	lw   $v1, 132($sp)
	sw   $v1, 96($sp)
	sw   $ra, -4($sp)
	lw   $a0, 100($sp)
	lw   $a1, 96($sp)
	jal  _m1__list__get
	lw   $ra, -4($sp)
	sw   $v0, 104($sp)
	lw   $v1, 108($sp)
	lw   $fp, 104($sp)
	sw   $v1, 0($fp)
	la   $a0, _s__2
	li   $v0, 4
	syscall
	lw   $a0, 132($sp)
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	addi $v1, $sp, 168
	sw   $v1, 116($sp)
	lw   $v1, 132($sp)
	sw   $v1, 112($sp)
	sw   $ra, -4($sp)
	lw   $a0, 116($sp)
	lw   $a1, 112($sp)
	jal  _m1__list__get
	lw   $ra, -4($sp)
	sw   $v0, 120($sp)
	lw   $v1, 120($sp)
	lw   $a0, 0($v1)
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	lw   $v1, 132($sp)
	sw   $v1, 128($sp)
	lw   $v1, 128($sp)
	addi $v1, $v1, 1
	sw   $v1, 124($sp)
	lw   $v1, 124($sp)
	sw   $v1, 132($sp)
	b    L188
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz ") = "
_s__2:
	.asciiz "F("
_vt__cell__cell:
_vt__list__list:

