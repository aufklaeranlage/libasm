; void ft_list_push_front(t_list **begin_list, void *data)
; return: , rdi: QWORD, rsi: QWORD

; We recieve pointers (memory addresses) to a struct with two pointers in them.
; The memory address should be 8 bytes in x86-64

		BITS 64

		global	ft_list_push_front:function

		extern	malloc

		section .text
ft_list_push_front:
	push	rdi 
	push	rsi

	mov		rdi, 0x10 ; Two pointes in a struct -> 2 * 8 = 0x10
	call	malloc wrt ..plt
	pop		rsi
	pop		rdi
	cmp		rax, 0x0 ;
	je		.end
	mov		QWORD [rax], rsi ; store data in allocated struct
	mov		rsi, [rdi]
	mov		QWORD [rax + 0x8], rsi
	mov		QWORD [rdi], rax
	jmp		.end

.end:
	ret
	
