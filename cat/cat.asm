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
	mov r15, [rsp]			; load argc into r15
	cmp r15, 2			; check if enough params provided
	jl .no_file

	mov r14, 2			; store the current arg number in r14

.dump_file:
	mov rax, 2			; open
	mov rdi, [rsp + 8 * r14]	; filename located at argv[1]
	mov rsi, 0			; O_RDONLY
	syscall

	mov r12, rax			; store FD in r12
	
	cmp rax, 0			; failed to open file
	jle .open_failed		; print error message. open_failed jumps back
					; so it can print the next file
	call .copy_file

	mov rax, 3			; close
	mov rdi, r12			; the file
	syscall

.dump_inc_file:
	inc r14				; increment file number
	cmp r14, r15			; check if we have done all the files
	jle .dump_file			; and go again if we haven't

	jmp .ok				; all done

.copy_file:
	mov rax, 0			; read from
	mov rdi, r12,			; FD
	mov rsi, buffer			; into buffer
	mov rdx, 512			; with a max size of 512
	syscall

	mov r13, rax			; store the amount of bytes read into r13

	cmp rax, 0			; check for EOF
	je .copy_done			; exit when done

	mov rax, 1			; write to
	mov rdi, 1			; stdout
	mov rsi, buffer,		; the contents of buffer
	mov rdx, r13			; but only the first r13 bytes
	syscall

	jmp .copy_file			; go again

.copy_done:
	ret				; all done

; TODO: display what file failed
.open_failed:
	mov rax, 1			; write
	mov rdi, 1			; to stdout
	mov rsi, open_failed		; open_failed
	mov rdx, open_failed_len	; the length of the msg

	syscall
	
	jmp .dump_inc_file

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
