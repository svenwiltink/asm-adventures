extern strlen
extern atoi

section .bss
buffer 		resb 512		; buffer for reading the inputfile
inputfile	resq 1			; pointer to the inputfile

section .data
	open_failed 		db "failed to open file", 10
	open_failed_len		equ $-open_failed
	no_file_provided 	db "no file provided", 10
	no_file_provided_len 	equ $-no_file_provided
	test_input		db "193", 0
	

section .text
global _start

_start:
	mov r12, [rsp]			; load argc into r12
	cmp r12, 2			; check if enough params provided
	jl .no_file

	mov rax, [rsp + 16]		; get the inputfile 
	mov [inputfile], rax		; and store in in inputfile


	call strlen

	mov rdx, rax			; set the length to print
	mov rax, 1			; write
	mov rdi, 1			; to stdout
	mov rsi, [inputfile]		; the name of the inputfile
	syscall
	
	mov rax, test_input
	call atoi

	

	jmp .ok


; exit conditions and error messages below this point
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
