	global ft_strcmp

	section .text

; int ft_strcmp(const char *s1, const char *s2) s1: RDI, s2: RSI
ft_strcmp:
	xor		rax, rax
	xor		rcx, rcx
_loop:
	mov		al, BYTE rdi[rcx]
	sub		al, BYTE rsi[rcx]
	jne		_end
	cmp		BYTE rdi[rax], 0x0
	je		_end
	add		rcx, 0x1
	jmp		_loop
_end:
	ret

