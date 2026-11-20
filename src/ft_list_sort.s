; void ft_list_size(t_list *begin_list, int (*cmp)())
; return: , rdi: QWORD, rsi: QWORD

		BITS 64

		global	ft_list_sort:function

		extern	malloc

		section .text
ft_list_sort:
	test rdi, rdi
	jz .end
	push rdi ; save head
	mov rdi, [rdi]
	call merge_sort
	pop rdi
	mov [rdi], rax
.end:
	ret

; Input: rdi QWORD head, rsi QWORD cmp func
; Output: rax QWORD sorted list
merge_sort:
	cmp QWORD [rdi + 0x8], 0x0 ; if head == NULL
	je .one_node ; return
	sub rsp, 0x18
	mov [rsp], r12
	mov [rsp + 0x8], r13
	mov [rsp + 0x10], r14

	mov r12, rdi
	mov r13, rdi
	mov r14, rsi

.find_mid:
	cmp QWORD [r13 + 0x8], 0x0 ; if end == NULL
	je .start_merge_sort ; break
	mov r13, [r13 + 0x8] ; end = end->next
	cmp QWORD [r13 + 0x8], 0x0 ; if end == NULL
	je .start_merge_sort ; break
	mov r12, [r12 + 0x8] ; mid = mid->next
	jmp .find_mid

.start_merge_sort:
	mov r13, [r12 + 0x8] ; right = mid->next
	mov QWORD [r12 + 0x8], 0x0 ; mid->next = NULL
	mov rsi, r14
	call merge_sort
	mov r12, rax

	mov rdi, r13
	mov rsi, r14
	call merge_sort
	mov r13, rax

.start_merge:
	mov rdi, r12
	mov rsi, r13
	mov rdx, r14
	call merge

	mov r14, [rsp + 0x10]
	mov r13, [rsp + 0x8]
	mov r12, [rsp]
	add rsp, 0x18
.end:
	ret

.one_node:
	mov rax, rdi
	ret

; Input: rdi QWORD left head, rsi QWORD right head, rdx QWORD cmp func
; Output: rax QWORD sorted list
merge:
	; Need to call cmp, not sure what cmp uses so store necessary values in save
	; registers (r12 - r14)
	sub rsp, 0x28
	mov [rsp], r12
	mov [rsp + 0x8], r13
	mov [rsp + 0x10], r14
	mov	[rsp + 0x18], r15
	mov QWORD [rsp + 0x20], 0x0

	mov r12, rdi
	mov r13, rsi
	mov r14, rdx
	lea r15, [rsp + 0x18]

.loop:
	test r12, r12
	jz .attach_right ; left empty, add remainder of right
	test r13, r13
	jz .attach_left ; right empty, add remainder of left

	mov rdi, [r12] ; left->data
	mov rsi, [r13] ; right->data
	call r14 ; call cmp
	cmp eax, 0x0
	jg .pick_right

.pick_left:
	mov [r15 + 8], r12 ; tail.next = left
	mov r15, r12 ; tail = left
	mov r12, [r12 + 0x8] ; left = left->next
	jmp .loop

.pick_right:
	mov [r15 + 8], r13 ; tail.next = right
	mov r15, r13 ; tail = right
	mov r13, [r13 + 0x8] ; right = right->next
	jmp .loop

.attach_left:
	mov [r15 + 8], r12 ; tail->next = left
	test r12, r12 ; if left == NULL
	jz .end
	mov r15, r12 ; tail = left
	mov r12, [r12 + 0x8] ; left = letf->next
	jmp .attach_left

.attach_right:
	mov [r15 + 8], r13 ; tail->next = right
	test r13, r13 ; if right == NULL
	jz .end
	mov r15, r13 ; tail = right
	mov r13, [r13 + 0x8] ; right = right->next
	jmp .attach_right

.end:
	mov rax, [rsp + 0x20]
	mov r15, [rsp + 0x18]
	mov r14, [rsp + 0x10]
	mov r13, [rsp + 0x8]
	mov r12, [rsp]
	add rsp, 0x28
	ret
