; ft_strlen(const char *) rdi: QWORD

		BITS	64

		global	ft_strlen:function
		section	.text

ft_strlen:
		mov		r9,rsi			; save rsi to be able to use it for prefix free sized comparison

		mov		rax,0			; use rax as counter
		mov		rsi,0			; init rsi to 0 for comparsion as BYTE 0

.loop:
		mov		sil,[rdi + rax]
		cmp		sil,0			; check byte at rdi against sil
		je		.break	
		add		rax,1			; increase string length returned
		jmp		.loop

.break:
		mov		rsi,r9
		ret
