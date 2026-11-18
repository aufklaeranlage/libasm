#ifndef LIBASM_H
# define LIBASM_H

# include <stdint.h>

size_t		ft_strlen(const char *s);

char		*ft_strcpy(char * restrict dest, const char * restrict src);

int			ft_strcmp(const char *s1, const char *s2);

ssize_t		ft_write(unsigned int fd, const char * buf, size_t count);

ssize_t		ft_read(unsigned int fd, char * buf, size_t count);

char		*ft_strdup(const char *s);

int			ft_atoi_base(const char *str, const char *base);

typedef struct s_list
{
	void *data;
	struct s_list *next;
} t_list;

void		ft_list_push_front(t_list **head, void *data);

#endif
