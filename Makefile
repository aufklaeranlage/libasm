# **************************************************************************** #
NAME := libasm.a

# * DIRECTORIES ************************************************************** #
SRC_DIR		:= src
OBJ_DIR		:= obj
INC_DIR		:= inc
TEST_DIR	:= test

# * FILES ******************************************************************** #
SRCS	:=
vpath %.s $(SRC_DIR)
SRCS	+= ft_strlen.s
SRCS	+= ft_strcpy.s
SRCS	+= ft_strcmp.s
SRCS	+= ft_write.s

OBJS	:= $(SRCS:.s=.o)
OBJS	:= $(addprefix $(OBJ_DIR)/,$(OBJS))

vpath %.c $(TEST_DIR)
TESTS	:= $(SRCS:.s=_test.c)

TEST_OBJS	:= $(TESTS:.c=.o)
TEST_OBJS	:= $(addprefix $(OBJ_DIR)/,$(TEST_OBJS))

TESTS	:= $(addprefix $(TEST_DIR)/,$(TESTS))

# * TOOLS ******************************************************************** #
CASM	:= nasm
CC		:= cc
AR		:= ar
LD		:= gcc
RM		:= rm -rf
MKDIR	:= mkdir

# * FLAGS ******************************************************************** #
CFLAGS	?=
CFLAGS	+= -f elf64

CPPFLAGS	?=

ARFLAGS	:= rcs

LDFLAGS	?=

# * RULES ******************************************************************** #
all: $(NAME)

$(NAME): $(OBJS)
	$(AR) $(ARFLAGS) $@ $(OBJS)

$(OBJ_DIR):
	$(MKDIR) $@

$(OBJ_DIR)/%.o: %.s $(OBJ_DIR)
	$(CASM) $(CPPFLAGS) $(CFLAGS) -o $@ $<

test: $(TEST_OBJS)

$(OBJ_DIR)/%.o: %.c $(OBJ_DIR) $(NAME)
	$(CC) -I$(INC_DIR) -c -o $@ $<
	$(LD) -o $(@:$(OBJ_DIR)/ft_%_test.o=%_test) $(@) $(@:%_test.o=%.o) -L. -l:$(NAME)

test_%: $(OBJ_DIR)/ft_%_test.o

clean:
	$(RM) $(OBJ_DIR)

fclean: clean
	$(RM) $(NAME)

re: fclean all

.PHONY: all clean fclean re
