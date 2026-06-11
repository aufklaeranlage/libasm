; int ft_strcmp(const char *s1, const char *s2) rdi: QWORD, rsi: QWORD
; return: DWORD, rdi: QWORD, rsi: QWORD

		BITS	64

		global	ft_strcmp:function

		section	.text
ft_strcmp:
	push	r8 ; save register
	xor		rax, rax
	xor		rcx, rcx

.loop:
	mov		al, BYTE rdi[rcx]
	mov		r8b, BYTE rsi[rcx]
	sub		eax, r8d
	jne		.end
	cmp		BYTE rdi[rcx], 0x0
	je		.end
	add		rcx, 0x1
	jmp		.loop

.end:
	pop		r8 ; restore register
	ret
