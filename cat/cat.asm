section .bss
buffer resb 512

section .data
	filename db "helloworld.txt", 0
	open_failed db "failed to open file "

section .text

global _start

_start:
	mov rax, 2
	mov rdi, filename
	mov rsi, 0
	syscall
	cmp rax, 0
	jl .open_failed
	mov r12, rax

.copy_file:
	mov rax, 0
	mov rdi, r12,
	mov rsi, buffer
	mov rdx, 512
	syscall

	mov r13, rax

	cmp rax, 0 ;EOF
	je .exit

	mov rax, 1
	mov rdi, 1
	mov rsi, buffer,
	mov rdx, r13
	syscall

	jmp .copy_file

.open_failed:
	mov rax, 1
	mov rdi, 1
	mov rsi, open_failed
	mov rdx, 20
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, filename
	mov rdx, 14
	syscall

	mov rax, 1

.exit:
	mov rdi, rax
	mov rax, 60
	syscall
