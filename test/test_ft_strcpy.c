#include <stdio.h>
#include <string.h>
#include "test_macros.h"

#include "libasm.h"

static bool	test_functionality(void)
{
	char	src[] = "Hello, World!";
	char	buf1[100];
	char	buf2[100];
	char	*ret;
	char	*ft_ret;

	ret = strcpy(buf1, src);
	ft_ret = ft_strcpy(buf2, src);
	fprintf(stdout, "src: %s, buf1: %s, buf2: %s, ret: %p ft_ret: %p\n", src, buf1, buf2, ret, ft_ret);
	return (strcmp(buf1, buf2));
}

static bool	test_zero_len(void)
{
	char	src[] = "";
	char	buf1[100];
	char	buf2[100];
	char	*ret;
	char	*ft_ret;

	ret = strcpy(buf1, src);
	ft_ret = ft_strcpy(buf2, src);
	fprintf(stdout, "src: %s, buf1: %s, buf2: %s, ret: %p ft_ret: %p\n", src, buf1, buf2, ret, ft_ret);
	return (strcmp(buf1, buf2));
}

int	main(void)
{
	TEST(test_functionality);
	TEST(test_zero_len);
	return (0);
}
