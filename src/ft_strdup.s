; char *strdup(const char *s)
; return: QWORD, rdi: QWORD

		BITS 64

		global	ft_strdup:function

		extern	ft_strlen
		extern	malloc
		extern	ft_strcpy

		section .text
ft_strdup:
	push	rdi ; save the pointer
	call	ft_strlen ; get the length of the string
	mov		rdi, rax ; set up the length of the string as byte count to allocate
	add		rdi, 0x1
	call	malloc
	cmp		rax, 0x0 ;
	je		.error
	mov		rdi, rax ; set up new allocated string as dest for ft_strcpy
	pop		rsi ; set up original string as src for ft_strcpy
	call	ft_strcpy
	jmp		.end

.error:
	pop		rdi

.end:
	ret
	
