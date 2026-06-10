	global ft_strcpy

	section .text

; char *ft_strcpy(char *dest, char *src) dest: RDI, src: RSI
ft_strcpy:
	xor		rax, rax
_loop:
	cmp		BYTE rsi[rax], 0x0
	mov		dl, BYTE rsi[rax]
	mov		BYTE rdi[rax], dl
	je		_end
	add		rax, 0x1
	jmp		_loop
_end:
	mov		rax, rdi
	ret
