; int32_t ft_strcmp(const char *s1, const char *s2) rdi: QWORD, rsi: QWORD
; Copy of strcmp (man 3)
		BITS	64

		global	ft_strcmp:function

		section	.text
ft_strcmp:
		mov		rax,0			; reset full register
		mov		r8,0			; reste full register
		mov		r9,0			; use as index

.loop:
		mov		al,[rdi + r9]	; load char from first string
		cmp		al,0			; check for the end of the first string
		je		.zero
		mov		r8b,[rsi + r9]	; load char from first string
		sub		eax,r8d			; subtract char from second string
		jnz		.break
		add		r9,1
		jmp		.loop

.zero:
		mov		r8b,[rsi + r9]
		sub		eax,r8d			; subtract char from second string to make sure we have a comparison
.break:
		ret
