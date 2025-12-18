#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include "test_macros.h"

#include "libasm.h"

static bool	test_ebadf(void) {
	size_t	ret;
	size_t	ft_ret;
	int	invalid_fd = 69;
	int	not_open_for_write = open("Makefile", O_RDONLY);

	printf("- EBADF: -------------------------------\n");
	ret = write(invalid_fd, "Hello, World!", 13);
	printf("write(): ret: %lu, strerror: %s\n", ret, strerror(ret));
	ft_ret = ft_write(invalid_fd, "Hello, World!", 13);
	printf("ft_write(): ft_ret: %lu, strerror: %s\n", ft_ret, strerror(ft_ret));
	return (ret == ft_ret);
}

int	main(void)
{
	TEST(test_ebadf);
}
