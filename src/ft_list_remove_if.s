; void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(void *, void *), void (*free_fct)(void *))
; return: , rdi: QWORD

		BITS 64

		global	ft_list_remove_if:function

		extern	free

		section .text
ft_list_remove_if:
	sub rsp, 0x28
	mov [rsp], r12
	mov [rsp + 0x8], r13
	mov [rsp + 0x10], r14
	mov [rsp + 0x18], r15
	mov [rsp + 0x20], rdi

	mov r12, rsi ; ref data
	mov r13, rdx ; cmp
	mov r14, rcx ; free

	test rdi, rdi ; Deny NULL on head ?
	jz .end
	; Not denying NULL cmp since we want a segfault on missing comparison func

	mov r15, [rdi] ; head

.check_head:
	test r15, r15 ; if cur == NULL
	jz .end

	mov rdi, [r15]
	mov rsi, r12
	call r13
	test eax, eax
	jnz .check_main

	test r14, r14
	jz .check_head_free_node
	mov rdi, [r15]
	call r14 ; free_fct(cur->data)
.check_head_free_node:
	mov rdi, r15
	mov r15, [r15 + 0x8]
	call free wrt ..plt ; free(cur)
	mov rdi, [rsp + 0x20]
	mov [rdi], r15 ; head = cur->next
	jmp .check_head

.check_main:
	cmp QWORD [r15 + 0x8], 0x0 ; if cur->next == NULL
	jz .end

	mov rdi, [r15 + 0x8] ; test = cur->next
	mov rdi, [rdi]
	mov rsi, r12
	call r13 ; cmp(cur->next->data, ref)
	test eax, eax
	jnz .check_main_inc

	test r14, r14
	jz .check_main_free_node
	mov rdi, [r15 + 0x8] ; tmp = cur->next
	mov rdi, [rdi]
	call r14 ; free_fct(tmp)
.check_main_free_node:
	mov rdi, [r15 + 0x8] ; tmp = cur->next
	mov rdi, [rdi + 0x8] ; tmp = tmp->next
	mov [r15 + 0x8], rdi ; cur->next = tmp | cur->next = cur->next->next
	mov r15, rdi
	mov rdi, [r15 + 0x8] ; tmp = cur->next
	call free wrt ..plt
	jmp .check_main

.check_main_inc:
	mov r15, [r15 + 0x8]
	jmp .check_main

.end:
	mov r15, [rsp + 0x18]
	mov r14, [rsp + 0x10]
	mov r13, [rsp + 0x8]
	mov r12, [rsp]
	add rsp, 0x28
	ret

; --- C Code ---
; void ft_list_remove_if(t_list **head, void *ref_data, int (*cmp)(void *, void *), void (*free_fct)) {
;	t_list *cur = *head;
;	while (cur != NULL && cmp(cur, ref_data) == 0) {
;		free_fct(cur->data);
;		t_list *tmp = cur->next;
;		free(cur);
;		cur = tmp;
;		*head = cur;
;	}
;	if (cur == NULL)
;		return;
;	while (cur->next != NULL) {
;		if (cmp(cur->next->data, ref_data) == 0) {
;			free_fct(cur->next->data);
;			t_list *tmp = cur->next;
;			cur->next = tmp->next;
;			free(tmp);
;		} else {
;			cur = cur->next;
;		}
;	}
; }
