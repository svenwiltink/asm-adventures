section .bss
buffer resb 512

section .data
	filename db "helloworld.txt", 0
	open_failed db "failed to open file "

section .text

global _start

_start:
	mov rax, 2			; open
	mov rdi, filename		; file
	mov rsi, 0			; O_RDONLY
	syscall
	cmp rax, 0
	jl .open_failed
	mov r12, rax			; store FD in r12

.copy_file:
	mov rax, 0			; read from
	mov rdi, r12,			; FD
	mov rsi, buffer			; into buffer
	mov rdx, 512			; with a max size of 512
	syscall

	mov r13, rax			; store the amount of bytes read into r13

	cmp rax, 0			; check for EOF 
	je .exit			; exit when done

	mov rax, 1			; write to
	mov rdi, 1			; stdout
	mov rsi, buffer,		; the contents of buffer
	mov rdx, r13			; but only the first r13 bytes
	syscall

	jmp .copy_file			; go again

.open_failed:
	mov rax, 1			; write
	mov rdi, 1			; to stdout
	mov rsi, open_failed		; open_failed
	mov rdx, 20			; the length of the msg
	syscall
	
	mov rax, 1			; write
	mov rdi, 1			; to stdout
	mov rsi, filename		; the filename
	mov rdx, 14			; the length of the msg
	syscall

	mov rax, 1			; set exitcode to 1

.exit:
	mov rdi, rax			; set exitcode
	mov rax, 60			; exit
	syscall
