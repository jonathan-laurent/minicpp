	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_m2__ListeC__supprimer:
	addi $sp, $sp, -4
	lw   $t1, 8($a0)
	lw   $t0, 4($a0)
	sw   $t1, 8($t0)
	lw   $t1, 4($a0)
	lw   $t0, 8($a0)
	sw   $t1, 4($t0)
	addi $sp, $sp, 4
	jr   $ra
_m1__ListeC__insererApres:
	addi $sp, $sp, -16
	sw   $s0, 8($sp)
	sw   $s1, 4($sp)
	sw   $s2, 0($sp)
	move $s1, $a0
	move $s0, $a1
	li   $a0, 16
	li   $v0, 9
	syscall
	move $s2, $v0
	la   $t0, _vt__ListeC__ListeC
	sw   $t0, 0($s2)
	li   $a1, 0
	sw   $ra, -4($sp)
	move $a0, $s2
	jal  _m0__ListeC__ListeC
	lw   $ra, -4($sp)
	sw   $s0, 12($s2)
	lw   $t0, 8($s1)
	sw   $t0, 8($s2)
	sw   $s2, 8($s1)
	move $t0, $s2
	lw   $t0, 8($t0)
	sw   $s2, 4($t0)
	sw   $s1, 4($s2)
	lw   $s0, 8($sp)
	lw   $s1, 4($sp)
	lw   $s2, 0($sp)
	addi $sp, $sp, 16
	jr   $ra
_m3__ListeC__afficher:
	addi $sp, $sp, -4
	move $t1, $a0
	move $t0, $t1
	lw   $a0, 12($t0)
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	lw   $t0, 8($t0)
L108:
	bne  $t0, $t1, L105
	la   $a0, _s__3
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
L105:
	lw   $a0, 12($t0)
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	lw   $t0, 8($t0)
	b    L108
_m0__ListeC__ListeC:
	addi $sp, $sp, -4
	sw   $a1, 12($a0)
	move $t0, $a0
	sw   $a0, 4($t0)
	move $t0, $a0
	sw   $t0, 8($a0)
	addi $sp, $sp, 4
	jr   $ra
_p0__main:
	addi $sp, $sp, -20
	addi $t1, $sp, 0
	la   $t0, _vt__ListeC__ListeC
	sw   $t0, 0($t1)
	addi $a0, $sp, 0
	li   $a1, 1
	sw   $ra, -4($sp)
	jal  _m0__ListeC__ListeC
	lw   $ra, -4($sp)
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m3__ListeC__afficher
	lw   $ra, -4($sp)
	addi $a0, $sp, 0
	li   $a1, 3
	sw   $ra, -4($sp)
	jal  _m1__ListeC__insererApres
	lw   $ra, -4($sp)
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m3__ListeC__afficher
	lw   $ra, -4($sp)
	addi $a0, $sp, 0
	li   $a1, 2
	sw   $ra, -4($sp)
	jal  _m1__ListeC__insererApres
	lw   $ra, -4($sp)
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m3__ListeC__afficher
	lw   $ra, -4($sp)
	lw   $a0, 8($sp)
	sw   $ra, -4($sp)
	jal  _m2__ListeC__supprimer
	lw   $ra, -4($sp)
	addi $a0, $sp, 0
	sw   $ra, -4($sp)
	jal  _m3__ListeC__afficher
	lw   $ra, -4($sp)
	li   $a0, 7
	sw   $ra, -4($sp)
	jal  _p1__cercle
	lw   $ra, -4($sp)
	sw   $ra, -4($sp)
	move $a0, $v0
	jal  _m3__ListeC__afficher
	lw   $ra, -4($sp)
	li   $a0, 7
	li   $a1, 5
	sw   $ra, -4($sp)
	jal  _p2__josephus
	lw   $ra, -4($sp)
	li   $t0, 6
	beq  $v0, $t0, L203
L170:
	addi $sp, $sp, 20
	jr   $ra
L203:
	li   $a0, 5
	li   $a1, 5
	sw   $ra, -4($sp)
	jal  _p2__josephus
	lw   $ra, -4($sp)
	li   $t0, 2
	bne  $v0, $t0, L170
	li   $a0, 5
	li   $a1, 17
	sw   $ra, -4($sp)
	jal  _p2__josephus
	lw   $ra, -4($sp)
	li   $t0, 4
	bne  $v0, $t0, L170
	li   $a0, 13
	li   $a1, 2
	sw   $ra, -4($sp)
	jal  _p2__josephus
	lw   $ra, -4($sp)
	li   $t0, 11
	bne  $v0, $t0, L170
	la   $a0, _s__0
	li   $v0, 4
	syscall
	b    L170
	b    L170
	b    L170
	b    L170
_p2__josephus:
	addi $sp, $sp, -12
	sw   $s0, 4($sp)
	sw   $s1, 0($sp)
	move $s1, $a1
	sw   $ra, -4($sp)
	jal  _p1__cercle
	lw   $ra, -4($sp)
	move $s0, $v0
L322:
	move $t0, $s0
	lw   $t1, 8($s0)
	bne  $t0, $t1, L318
	lw   $v0, 12($s0)
	lw   $s0, 4($sp)
	lw   $s1, 0($sp)
	addi $sp, $sp, 12
	jr   $ra
L318:
	li   $t0, 1
L316:
	slt  $t1, $t0, $s1
	bnez $t1, L312
	sw   $ra, -4($sp)
	move $a0, $s0
	jal  _m2__ListeC__supprimer
	lw   $ra, -4($sp)
	lw   $s0, 8($s0)
	b    L322
L312:
	lw   $s0, 8($s0)
	addi $t0, $t0, 1
	b    L316
_p1__cercle:
	addi $sp, $sp, -12
	sw   $s0, 4($sp)
	sw   $s1, 0($sp)
	move $s0, $a0
	li   $a0, 16
	li   $v0, 9
	syscall
	move $s1, $v0
	la   $t0, _vt__ListeC__ListeC
	sw   $t0, 0($s1)
	li   $a1, 1
	sw   $ra, -4($sp)
	move $a0, $s1
	jal  _m0__ListeC__ListeC
	lw   $ra, -4($sp)
L367:
	li   $t0, 2
	sge  $t0, $s0, $t0
	bnez $t0, L363
	move $v0, $s1
	lw   $s0, 4($sp)
	lw   $s1, 0($sp)
	addi $sp, $sp, 12
	jr   $ra
L363:
	sw   $ra, -4($sp)
	move $a0, $s1
	move $a1, $s0
	jal  _m1__ListeC__insererApres
	lw   $ra, -4($sp)
	addi $s0, $s0, -1
	b    L367
	.data
_s__0:
	.asciiz "ok\n"
_s__1:
	.asciiz " "
_s__2:
	.asciiz " "
_s__3:
	.asciiz "\n"
_vt__ListeC__ListeC:

