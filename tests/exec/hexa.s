	.text
	jal  _p0__main
	li   $v0, 10
	syscall
_p0__main:
	addi $sp, $sp, -4
	li   $a0, 0x100
	li   $v0, 1
	syscall
	la   $a0, _s__0
	li   $v0, 4
	syscall
	li   $a0, 0xff
	li   $v0, 1
	syscall
	la   $a0, _s__1
	li   $v0, 4
	syscall
	li   $a0, 0xFF
	li   $v0, 1
	syscall
	la   $a0, _s__2
	li   $v0, 4
	syscall
	li   $a0, 0x7fffffff
	li   $v0, 1
	syscall
	la   $a0, _s__3
	li   $v0, 4
	syscall
	li   $a0, 0xDEADBEEF
	li   $v0, 1
	syscall
	la   $a0, _s__4
	li   $v0, 4
	syscall
	li   $a0, 0xFFFFFFFF
	li   $v0, 1
	syscall
	la   $a0, _s__5
	li   $v0, 4
	syscall
	li   $a0, 0x80000000
	li   $v0, 1
	syscall
	la   $a0, _s__6
	li   $v0, 4
	syscall
	addi $sp, $sp, 4
	jr   $ra
	.data
_s__0:
	.asciiz "\n"
_s__1:
	.asciiz "\n"
_s__2:
	.asciiz "\n"
_s__3:
	.asciiz "\n"
_s__4:
	.asciiz "\n"
_s__5:
	.asciiz "\n"
_s__6:
	.asciiz "\n"

