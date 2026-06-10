	global ft_strlen

	section .text

; size_t ft_strlen(char *str) str: RDI
ft_strlen:
	xor		rax, rax	; zero rax and use as counter
_loop:
	cmp		BYTE rdi[rax], 0x0
	je		_end
	add		rax, 0x1
	jmp		_loop
_end:
	ret
