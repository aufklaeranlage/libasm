; char *ft_strcpy(char * restrict dest, const const * restrict src)
; return: QWORD, rdi: QWORD, rsi: QWORD

		BITS	64

		global	ft_strcpy:function
		
		section	.text
ft_strcpy:
	xor		rax, rax

.loop:
	cmp		BYTE rsi[rax], 0x0
	mov		dl, BYTE rsi[rax]
	mov		BYTE rdi[rax], dl
	je		.end
	add		rax, 0x1
	jmp		.loop

.end:
	mov		rax, rdi
	ret
