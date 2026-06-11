#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "test_macros.h"

#include "libasm.h"

static bool test_norm(void) {
	char	*str = "Hello, World!";
	char	*dup, *ft_dup;
	int		ret;

	dup = strdup(str);
	ft_dup = ft_strdup(str);
	fprintf(stdout, "str: %s, strdup: %s, ft_strdup: %s\n", str, dup, ft_dup);
	ret = strcmp(dup, ft_dup);
	free(dup);
	free(ft_dup);
	return (ret == 0);
}

static bool test_zero(void) {
	char	*str = "";
	char	*dup, *ft_dup;
	int		ret;

	dup = strdup(str);
	ft_dup = ft_strdup(str);
	fprintf(stdout, "str: %s, strdup: %s, ft_strdup: %s\n", str, dup, ft_dup);
	ret = strcmp(dup, ft_dup);
	free(dup);
	free(ft_dup);
	return (ret == 0);
}

int main() {
	TEST(test_norm);
	TEST(test_zero);
}
