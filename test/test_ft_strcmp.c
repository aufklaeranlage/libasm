#include <stdio.h>
#include <string.h>
#include "test_macros.h"

#include "libasm.h"

static bool	test_above(void)
{
	char	str1[] = "Hello, World!";
	char	str2[] = "World, Hello!";
	ssize_t	ret;
	ssize_t	ft_ret;

	ret = strcmp(str1, str2);
	ft_ret = ft_strcmp(str1, str2);
	fprintf(stdout, "str1: %s, str2: %s, ret: %ld ft_ret: %ld\n", str1, str2, ret, ft_ret);
	return (ret == ft_ret);
}

static bool	test_below(void)
{
	char	str1[] = "World, Hello!";
	char	str2[] = "Hello, World!";
	ssize_t	ret;
	ssize_t	ft_ret;

	ret = strcmp(str1, str2);
	ft_ret = ft_strcmp(str1, str2);
	fprintf(stdout, "str1: %s, str2: %s, ret: %ld ft_ret: %ld\n", str1, str2, ret, ft_ret);
	return (ret == ft_ret);
}

static bool	test_zero(void)
{
	char	str1[] = "Hello, World!";
	char	str2[] = "Hello, World!";
	ssize_t	ret;
	ssize_t	ft_ret;

	ret = strcmp(str1, str2);
	ft_ret = ft_strcmp(str1, str2);
	fprintf(stdout, "str1: %s, str2: %s, ret: %ld ft_ret: %ld\n", str1, str2, ret, ft_ret);
	return (ret == ft_ret);
}

int	main(void)
{
	TEST(test_above);
	TEST(test_below);
	TEST(test_zero);
	return (0);
}
