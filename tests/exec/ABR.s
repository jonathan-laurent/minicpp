	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m1__ABR__insere:
	addi $sp, $sp, -12
	sw   $s0, 4($sp)
	sw   $s1, 0($sp)
	move $s1, $a0
	move $a2, $a1
	lw   $t0, 12($s1)
	beq  $a2, $t0, L76
	lw   $t0, 12($s1)
	slt  $t0, $a2, $t0
	bnez $t0, L70
	lw   $t1, 4($s1)
	li   $t0, 0
	beq  $t1, $t0, L36
	lw   $a0, 4($s1)
	sw   $ra, -4($sp)
	move $a1, $a2
	jal  _m1__ABR__insere
	lw   $ra, -4($sp)
L10:
	lw   $s0, 4($sp)
	lw   $s1, 0($sp)
	addi $sp, $sp, 12
	jr   $ra
L36:
	li   $a0, 16
	li   $v0, 9
	syscall
	move $s0, $v0
	la   $t0, _vt__ABR__ABR
	sw   $t0, 0($s0)
	li   $a1, 0
	li   $a3, 0
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m0__ABR__ABR
	lw   $ra, -4($sp)
	sw   $s0, 4($s1)
	b    L10
L70:
	lw   $t1, 8($s1)
	li   $t0, 0
	beq  $t1, $t0, L66
	lw   $a0, 8($s1)
	sw   $ra, -4($sp)
	move $a1, $a2
	jal  _m1__ABR__insere
	lw   $ra, -4($sp)
	b    L10
L66:
	li   $a0, 16
	li   $v0, 9
	syscall
	move $s0, $v0
	la   $t0, _vt__ABR__ABR
	sw   $t0, 0($s0)
	li   $a1, 0
	li   $a3, 0
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m0__ABR__ABR
	lw   $ra, -4($sp)
	sw   $s0, 8($s1)
	b    L10
L76:
	b    L10
_m3__ABR__contient:
	addi $sp, $sp, -4
	lw   $t0, 12($a0)
	beq  $a1, $t0, L138
	lw   $t0, 12($a0)
	slt  $t0, $a1, $t0
	bnez $t0, L131
L117:
	lw   $t1, 4($a0)
	li   $t0, 0
	bne  $t1, $t0, L113
	li   $v0, 0
L101:
	addi $sp, $sp, 4
	jr   $ra
L113:
	lw   $a0, 4($a0)
	sw   $ra, -4($sp)
	jal  _m3__ABR__contient
	lw   $ra, -4($sp)
	b    L101
L131:
	lw   $t1, 8($a0)
	li   $t0, 0
	beq  $t1, $t0, L117
	lw   $a0, 8($a0)
	sw   $ra, -4($sp)
	jal  _m3__ABR__contient
	lw   $ra, -4($sp)
	b    L101
	b    L117
L138:
	li   $v0, 1
	b    L101
_m2__ABR__affiche:
	addi $sp, $sp, -8
	sw   $s0, 0($sp)
	move $s0, $a0
	lw   $t1, 8($s0)
	li   $t0, 0
	bne  $t1, $t0, L189
L183:
	la   $a0, _s__4
	li   $v0, 4
	syscall
	lw   $a0, 12($s0)
	li   $v0, 1
	syscall
	la   $a0, _s__3
	li   $v0, 4
	syscall
	lw   $t1, 4($s0)
	li   $t0, 0
	bne  $t1, $t0, L169
L163:
	lw   $s0, 0($sp)
	addi $sp, $sp, 8
	jr   $ra
L169:
	lw   $a0, 4($s0)
	sw   $ra, -4($sp)
	jal  _m2__ABR__affiche
	lw   $ra, -4($sp)
	b    L163
L189:
	lw   $a0, 8($s0)
	sw   $ra, -4($sp)
	jal  _m2__ABR__affiche
	lw   $ra, -4($sp)
	b    L183
_m0__ABR__ABR:
	addi $sp, $sp, -4
	sw   $a2, 12($a0)
	sw   $a1, 8($a0)
	sw   $a3, 4($a0)
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -20
	addi $t1, $sp, 0
	la   $t0, _vt__ABR__ABR
	sw   $t0, 0($t1)
	addi $a0, $sp, 0
	li   $a1, 0
	li   $a2, 1
	li   $a3, 0
	sw   $ra, -4($sp)
	jal  _m0__ABR__ABR
	lw   $ra, -4($sp)
	addi $a0, $sp, 0
	li   $a1, 17
	sw   $ra, -4($sp)
	jal  _m1__ABR__insere
	lw   $ra, -4($sp)
	addi $a0, $sp, 0
	li   $a1, 5
	sw   $ra, -4($sp)
	jal  _m1__ABR__insere
	lw   $ra, -4($sp)
	addi $a0, $sp, 0
	li   $a1, 8
	sw   $ra, -4($sp)
	jal  _m1__ABR__insere
	lw   $ra, -4($sp)
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m2__ABR__affiche
	lw   $ra, -4($sp)
	la   $a0, _s__0
	li   $v0, 4
	syscall
	addi $a0, $sp, 0
	li   $a1, 5
	sw   $ra, -4($sp)
	jal  _m3__ABR__contient
	lw   $ra, -4($sp)
	bnez $v0, L285
L253:
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m2__ABR__affiche
	lw   $ra, -4($sp)
	la   $a0, _s__2
	li   $v0, 4
	syscall
	addi $sp, $sp, 20
	jr   $ra
L285:
	addi $a0, $sp, 0
	li   $a1, 0
	sw   $ra, -4($sp)
	jal  _m3__ABR__contient
	lw   $ra, -4($sp)
	seq  $t0, $v0, $0
	beqz $t0, L253
	addi $a0, $sp, 0
	li   $a1, 17
	sw   $ra, -4($sp)
	jal  _m3__ABR__contient
	lw   $ra, -4($sp)
	beqz $v0, L253
	addi $a0, $sp, 0
	li   $a1, 3
	sw   $ra, -4($sp)
	jal  _m3__ABR__contient
	lw   $ra, -4($sp)
	seq  $t0, $v0, $0
	beqz $t0, L253
	la   $a0, _s__1
	li   $v0, 4
	syscall
	b    L253
	b    L253
	b    L253
	b    L253
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "ok\n"
_s__2:
	.asciiz "\n"
_s__3:
	.asciiz ")"
_s__4:
	.asciiz "("
_vt__ABR__ABR:

