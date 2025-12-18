; QWORD	ft_write(int fd, const void *buf, size_t count)
; rdi: fd, rsi: *buf, rdx: count
; Copy of write (man 2)
		BITS 64

		global	ft_write:function

		section	.text
ft_write:
		mov		rax,0
		syscall
		ret
