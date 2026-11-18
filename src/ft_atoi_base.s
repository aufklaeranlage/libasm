; int ft_atoi_base(char *str, char *base)
; return: DWORD, rdi: QWORD, rsi: QWORD
		BITS 64

		global	ft_atoi_base:function

		section .text
ft_atoi_base:
	; variables: string (rdi), base (rsi), signedness (r8),
	; result (rdx:rax), baselen (r9), strpos (rcx)
	push	rbp
	mov		rbp, rsp

	; Check for valid base
	mov		rax, -0x1
	xor		rcx, rcx
	sub		rsp, 256 ; make room for ascii characters

	; Init base character array to zero
.l_init_base_chars:
	mov		QWORD [rsp + rcx * 0x8], rax
	inc		rcx
	cmp		rcx, 0x20
	jne		.l_init_base_chars

.l_init_base_chars_end:
	xor		rcx, rcx
	xor		rax, rax

.l_add_base_chars:
	mov		al, BYTE [rsi + rcx]
	cmp		al, 0x0
	je		.l_add_base_chars_end
	cmp		al, 0x20 ; Deny all control characters + space
	jbe		.err
	cmp		al, 0x2B ; '+'
	je		.err
	cmp		al, 0x2D ; '-'
	je		.err
	cmp		al, 0x7F ; Deny all non ascii characters
	jae		.err
	mov		r8b, BYTE [rsp + rax]
	cmp		r8b, -0x1; Check for duplicate -- Value already set
	jne		.err ; base contains duplicate
	mov		BYTE [rsp + rax], cl ; save position in string in place
	inc		rcx
	jmp		.l_add_base_chars

.l_add_base_chars_end:
	cmp		rcx, 0x1 ; Check for base length over 1
	jbe		.err ; base too short

	mov		r9, rcx ; store base length in r9

	; Skip white space
	xor		rcx, rcx
.l_skip_ws:
	mov		al, BYTE [rdi + rcx]
	cmp		al, 0x9
	jb		.l_skip_ws_end
	cmp		al, 0xD
	jbe		.l_skip_ws_inc
	cmp		al, 0x20 ; ' '
	jne		.l_skip_ws_end
.l_skip_ws_inc:
	inc		rcx
	jmp		.l_skip_ws

.l_skip_ws_end:
	; Determine Signedness
	mov		rsi, -0x1 ; Base is stored in array on stack; Need reg for cmov
	mov		r8, 0x1 ; set plus to true by default
	mov		al, BYTE [rdi + rcx]
	cmp		al, 0x2D ; '-'
	cmove	r8, rsi
	je		.check_post_sign
	cmp		al, 0x2B ; '+'
	je		.check_post_sign
	jmp		.make_num

.check_post_sign:
	inc		rcx
	mov		al, BYTE [rdi + rcx]
	cmp		al, 0x2B ; '+'
	je		.err
	cmp		al, 0x2D ; '-'
	je		.err

.make_num:
	xor		rax, rax
	xor		rsi, rsi

.l_make_num:
	mov		sil, BYTE [rdi + rcx] ; Get character
	mov		sil, BYTE [rsp + rsi] ; Get character's base position
	cmp		sil, -0x1
	je		.add_signedness
	imul	eax, r9d ; limit to 32 bits
	jo		.err ; if overflow return 0
	add		eax, esi
	inc		rcx
	jmp		.l_make_num

.add_signedness:
	imul	eax, r8d
	jo		.err ; overflow
	jmp		.finish

.err:
	mov		rax, 0x0

.finish:
	mov		rsp, rbp
	pop		rbp
	ret
