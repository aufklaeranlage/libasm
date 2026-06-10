	global ft_write

SYS_WRITE   equ 1

	section .text

; ssize_t ft_write(int fd, char *str, size_t count)
ft_write:
	mov		rax, SYS_WRITE
	syscall
	ret
