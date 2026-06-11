; size_t ft_strlen(const char *)
; return: QWORD, rdi: QWORD

		BITS	64

		global	ft_strlen:function

		section	.text
ft_strlen:
	xor		rax, rax	; zero rax and use as counter

.loop:
	cmp		BYTE rdi[rax], 0x0
	je		.end
	add		rax, 0x1
	jmp		.loop

.end:
	ret
