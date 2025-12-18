#ifndef TEST_MACROS_H
# define TEST_MACROS_H

# include <stdbool.h>
# include <stdio.h>

# define TEST(funcname) fprintf(stdout, "\e[30;47m " #funcname " \e[0m\n"); if ((funcname)() != true) { fprintf(stderr, "Error: " #funcname "\n"); }

#endif
