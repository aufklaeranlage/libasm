; ssize_t ft_write(int fd, const void *buf, size_t count)
; return: QWORD. rdi: DWORD, rsi: QWORD, rdx: QWORD

		BITS 64

		SYS_WRITE	equ 1

		global	ft_write:function

		extern	__errno_location

		section	.text
ft_write:
		mov		rax, SYS_WRITE
		syscall
		cmp		rax, 0x0
		jl		.error
		ret
.error:
		neg		rax					; see syscall (2). return needs to be negated to hold the proper error number
		push	rax					; save error number
		call	__errno_location WRT ..plt	; get location of errno
		; uses WRT ..plt to be position independent. See NASM Manual 11.2.5
		pop		rdi					; restore error number
		mov		[rax], edi			; set errno to saved error number (DWORD size)
		mov		rax, -1
		ret
