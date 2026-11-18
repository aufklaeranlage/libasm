; void ft_list_size(t_list *begin_list)
; return: , rdi: QWORD

		BITS 64

		global	ft_list_size:function

		extern	malloc

		section .text
ft_list_size:
	push	rdi 

	xor		rax, rax

.l_count:
	cmp		rdi, 0x0
	je		.end
	mov		rdi, QWORD [rdi + 0x8]
	inc		rax
	jmp		.l_count

.end:
	pop		rdi
	ret
	
