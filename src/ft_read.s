; QWORD	ft_read(int fd, const void *buf, size_t count)
; rdi: fd, rsi: *buf, rdx: count
; Copy of read (man 2)
		BITS 64

		global	ft_read:function

		extern	__errno_location
		section	.text
ft_read:
		mov		rax,0
		syscall
		cmp		rax,0
		jl		.error
		ret
.error:
		neg		rax					; see syscall (2). return needs to be negated to hold the proper error number
		mov		rdi,rax				; save error number
		call	__errno_location	; get location of errno
		mov		[rax],rdi			; set errno to saved error number
		mov		rax,-1
		ret
