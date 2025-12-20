#ifndef LIBASM_H
# define LIBASM_H

# include <stdint.h>

uint64_t	ft_strlen(const char *s);

int8_t		*ft_strcpy(char * restrict dest, const char * restrict src);

int32_t		ft_strcmp(const char *s1, const char *s2);

int64_t		ft_write(unsigned int fd, const char * buf, size_t count);

int64_t		ft_read(unsigned int fd, char * buf, size_t count);

#endif
