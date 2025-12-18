#include <stdio.h>
#include <string.h>

#include "libasm.h"

int	main(int ac, const char *av[])
{
	char	src[] = "Hello, World!";
	char	buffer[100];
	char	*ptr;

	if (ac <= 1)
		return (1);
	printf("str: %s, strlen: %lu, ft_strlen: %lu\n",
			av[1],
			strlen(av[1]),
			ft_strlen(av[1]));

	ptr = strcpy(buffer, src);
	printf("before ft_strcpy:\nbuffer: %s, ptr: %p\n", buffer, ptr);
	ptr = strcpy(buffer, "World, Hell!");
	printf("after ft_strcpy:\nbuffer: %s, ptr: %p\n", buffer, ptr);
	printf("'%s' : '%s', strcmp: %d, ft_strcmp: %d\n", buffer, src, strcmp(buffer, src), ft_strcmp(buffer, src));
	printf("'%s' : '%s', strcmp: %d, ft_strcmp: %d\n", src, buffer, strcmp(src, buffer), ft_strcmp(src, buffer));
	write()
	return (0);
}
