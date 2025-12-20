#define _GNU_SOURCE

#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
#include "test_macros.h"

#include "libasm.h"

static bool	test_ebadf_invalid(void) {
	size_t	ret;
	size_t	ft_ret;
	int	invalid_fd = 69;
	int	not_open_for_write = open("Makefile", O_RDONLY);

	errno = 0;
	ret = write(invalid_fd, "Hello, World!", 13);
	printf("write(): fd: %d,  ret: %ld, strerror: %s\n", invalid_fd, ret, strerror(errno));
	errno = 0;
	ft_ret = ft_write(invalid_fd, "Hello, World!", 13);
	printf("ft_write(): fd: %d, ft_ret: %ld, strerror: %s\n", invalid_fd, ft_ret, strerror(errno));
	return (ret == ft_ret);
}

static bool	test_ebadf_rdonly(void) {
	size_t	ret;
	size_t	ft_ret;
	int		rdonly_fd = open("Makefile", O_RDONLY);

	errno = 0;
	ret = write(rdonly_fd, "Hello, World!", 13);
	printf("write(): fd: %d, ret: %ld, strerror: %s\n", rdonly_fd, ret, strerror(errno));
	errno = 0;
	ft_ret = ft_write(rdonly_fd, "Hello, World!", 13);
	printf("ft_write(): fd: %d, ft_ret: %ld, strerror: %s\n", rdonly_fd, ft_ret, strerror(errno));
	return (ret == ft_ret);
}

static bool	test_efault(void) {
	size_t	ret;
	size_t	ft_ret;
	int		fd = open("/tmp", O_RDWR | O_TMPFILE, S_IRUSR | S_IWUSR);

	errno = 0;
	ret = write(fd, (const char *)0xff, 13);
	printf("write(): fd: %d, ret: %ld, strerror: %s\n", fd, ret, strerror(errno));
	errno = 0;
	ft_ret = ft_write(fd, (const char *)0xff, 13);
	printf("ft_write(): fd: %d, ft_ret: %ld, strerror: %s\n", fd, ft_ret, strerror(errno));
	close(fd);
	return (ret == ft_ret);
}

int	main(void)
{
	TEST(test_ebadf_invalid);
	TEST(test_ebadf_rdonly);
	TEST(test_efault);
}
