#include <stdint.h>
#include <string.h>
#include <stdio.h>

#include "libasm.h"

int	main() {
	const char *strs[10] = {
		"adventure",
		"character",
		"huge",
		"outline",
		"net",
		"reject",
		"creep",
		"sympathetic",
		"disturbance",
		"convention"
	};
	for (int i = 0; i < 10; i++) {
		printf("str: %s, ft_strlen: %zu, strlen: %zu\n", strs[i], ft_strlen(strs[i]), strlen(strs[i]));
	}
	return (0);
}
