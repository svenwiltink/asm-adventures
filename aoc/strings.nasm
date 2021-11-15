section .text

global strlen
global atoi

; strlen returns the length of a null terminated string
; rax must contain the address of the first char
; 
; rax will contain the length of the string
strlen:
	mov rdi, rax			; free rax by moving the file to rdi
	xor rax, rax 			; set the counter to 0
	
strlen_check:
	cmp [rdi], byte 0		; check for null byte
	jz done

	inc rax
	inc rdi
	jmp strlen_check

; atoi takes a string in rax and converts it into an integer. 
; if rdi is 0 a null terminated string is used.
; if rdi is > 0 the string is assumed to be rdi length.
; The result is also placed in rax
atoi:
	mov rdx, rdi			; save rdx
	add rdx, rax			; calculate the end address of the string
	
	mov rdi, rax			; save rax 
	xor rax, rax            ; Set initial total to 0

     
atoi_convert:
    	movzx rsi, byte [rdi]   ; Get the current character

		test rdx, rdx			; null terminated?
		je .atoi_convert_null_terminated

		cmp rdx, rdi			; check if end of string
		je done					; done
		jmp .atoi_convert_calculate

.atoi_convert_null_terminated:
    	test rsi, rsi           ; Check for \0
    	je done

.atoi_convert_calculate:
    
    	cmp rsi, 48             ; Anything less than 0 is invalid
    	jl error
    
    	cmp rsi, 57             ; Anything greater than 9 is invalid
    	jg error
     
    	sub rsi, 48             ; Convert from ASCII to decimal 
    	imul rax, 10            ; Multiply total by 10
    	add rax, rsi            ; Add current digit to total
    
    	inc rdi                 ; Get the address of the next character
    	jmp atoi_convert

error:
    	mov rax, -1             ; Return -1 on error
 
done:
    	ret                     ; Return total or error code
