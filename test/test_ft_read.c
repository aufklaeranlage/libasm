#define _GNU_SOURCE

#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
#include "test_macros.h"

#include "libasm.h"

static bool	test_ebadf_invalid(void) {
	char	buf[100];
	size_t	ret;
	size_t	ft_ret;
	int	invalid_fd = 69;

	errno = 0;
	ret = read(invalid_fd, buf, 13);
	printf("read(): fd: %d,  ret: %ld, strerror: %s\n", invalid_fd, ret, strerror(errno));
	errno = 0;
	ft_ret = ft_read(invalid_fd, buf, 13);
	printf("ft_read(): fd: %d, ft_ret: %ld, strerror: %s\n", invalid_fd, ft_ret, strerror(errno));
	return (ret == ft_ret);
}

static bool	test_ebadf_wronly(void) {
	char	buf[100];
	size_t	ret;
	size_t	ft_ret;
	int		wronly_fd = open("Makefile", O_WRONLY);

	errno = 0;
	ret = read(wronly_fd, buf, 13);
	printf("read(): fd: %d, ret: %ld, strerror: %s\n", wronly_fd, ret, strerror(errno));
	errno = 0;
	ft_ret = ft_read(wronly_fd, buf, 13);
	printf("ft_read(): fd: %d, ft_ret: %ld, strerror: %s\n", wronly_fd, ft_ret, strerror(errno));
	return (ret == ft_ret);
}

static bool	test_eisdir(void) {
	size_t	ret;
	size_t	ft_ret;
	int		fd = open(".", O_RDONLY);

	errno = 0;
	ret = read(fd, (char *)0xff, 13);
	printf("read(): fd: %d, ret: %ld, strerror: %s\n", fd, ret, strerror(errno));
	errno = 0;
	ft_ret = ft_read(fd, (char *)0xff, 13);
	printf("ft_read(): fd: %d, ft_ret: %ld, strerror: %s\n", fd, ft_ret, strerror(errno));
	close(fd);
	return (ret == ft_ret);
}

static bool test_read() {
	char	buf[100];
	size_t	ret;
	size_t	ft_ret;
	int		fd = open("Makefile", O_RDONLY);

	errno = 0;
	ret = read(fd, buf, 13);
	printf("read(): fd: %d, buf: %s, ret: %ld, strerror: %s\n", fd, buf, ret, strerror(errno));
	lseek(fd, 0, SEEK_SET);
	errno = 0;
	ft_ret = ft_read(fd, buf, 13);
	printf("ft_read(): fd: %d, buf: %s, ft_ret: %ld, strerror: %s\n", fd, buf, ft_ret, strerror(errno));
	return (ret == ft_ret);

}

int	main(void)
{
	TEST(test_ebadf_invalid);
	TEST(test_ebadf_wronly);
	TEST(test_eisdir);
	TEST(test_read);
}
