; char *ft_strcpy(char * restrict dest, const const * restrict src) rdi: QWORD, rsi: QWORD
; Copy of strcpy (man 3)
		BITS	64

		global	ft_strcpy:function
		
		section	.text
ft_strcpy:
		mov		r8,0			; use as index

.loop:
		mov		al,[rsi + r8]	; load char into rax
		mov		[rdi + r8],al	;
		add		r8,1
		cmp		al,0			; check for end of string
		jne		.loop
		mov		rax,rdi			; return dest
		ret
