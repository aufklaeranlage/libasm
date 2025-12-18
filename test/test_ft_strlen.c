#include <stdio.h>
#include <string.h>
#include "test_macros.h"

#include "libasm.h"

static bool	test_norm(void)
{
	char	str[] = "Hello, World!";
	size_t	ret;
	size_t	ft_ret;

	ret = strlen(str);
	ft_ret = ft_strlen(str);
	fprintf(stdout, "str: %s, ret: %lu, ft_ret: %lu\n", str, ret, ft_ret);
	return (ret == ft_ret);
}

static bool	test_zero(void)
{
	char	str[] = "";
	size_t	ret;
	size_t	ft_ret;

	ret = strlen(str);
	ft_ret = ft_strlen(str);
	fprintf(stdout, "str: %s, ret: %lu, ft_ret: %lu\n", str, ret, ft_ret);
	return (ret == ft_ret);
}

int	main(void)
{
	TEST(test_norm);
	TEST(test_zero);
	return (0);
}
