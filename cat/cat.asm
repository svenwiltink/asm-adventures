section .bss
buffer resb 512

section .data
	open_failed 		db "failed to open file", 10
	open_failed_len		equ $-open_failed
	no_file_provided 	db "no file provided", 10
	no_file_provided_len 	equ $-no_file_provided
	

section .text

global _start

_start:
	mov rax, [rsp]			; load argc
	cmp rax, 2			; check if enough params provided
	jl .no_file

	;mov rax, 1			; write to
	;mov rdi, 1			; stdout
	;mov rdx, 12			; but only the first r13 bytes
	;syscall

	mov rax, 2			; open
	mov rdi, [rsp + 16]		; filename located at argv[1]
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
	je .ok				; exit when done

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
	mov rdx, open_failed_len	; the length of the msg

	syscall
	
	jmp .fail

.no_file:
	mov rax, 1			; write
	mov rdi, 1			; to stdout
	mov rsi, no_file_provided	; no_file_provided
	mov rdx, no_file_provided_len	; the length of the msg
	syscall

	jmp .fail

.ok:
	mov rdi, 0
	jmp .exit

.fail:
	mov rdi, 1

; exit. Assumes rdi contains the exitcode
.exit:
	mov rax, 60			; exit
	syscall
