# **************************************************************************** #
NAME := libasm.l

# * DIRECTORIES ************************************************************** #
SRC_DIR := src
OBJ_DIR := obj
TST_DIR	:= test

# * FILES ******************************************************************** #
SRC :=
vpath %.s $(SRC_DIR)/
SRC += ft_strlen.s
SRC += ft_strcpy.s
SRC += ft_strcmp.s
SRC += ft_write.s
SRC += ft_read.s
SRC += ft_strdup.s

OBJ := $(SRC:.s=.o)
OBJ := $(addprefix $(OBJ_DIR)/, $(OBJ))

DEP := $(OBJ:.o=.d)

TST	:= $(SRC:.s=.c)
TST := $(addprefix $(TST_DIR)/test_, $(TST))

TST_OUT := $(TST:.c=.out)

# * TOOLS ******************************************************************** #
CA := nasm
CC := cc
LD := ld
AR := ar

RM := rm -rf
MKDIR := mkdir

# * FLAGS *************************************************************************** #
CPPFLAGS := 

CAFLAGS :=
CAFLAGS += -w+error=all
CAFLAGS += -f elf64
CAFLAGS += -MP

LDFLAGS :=

ARFLAGS := rsc

CFLAGS :=

LDFLAGS :=
LDFLAGS += -L. -l:libasm.l
LDFLAGS += -z noexecstack # prevents ld complainign about missing .not.GNU-stack
# https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ffcf9c5700e49c0aee42dcba9a12ba21338e8136 

ifdef DEBUG
	CAFLAGS += -g -F dwarf
	CAFLAGS += -O0
	CFLAGS	+= -g3
else
# Minimize branch offsets, and signed immediate bytes, by overriding size specification unless strict is used
	CAFLAGS += -Ox
endif

# * RULES ******************************************************************** #

all: $(NAME)

$(NAME): $(OBJ_DIR) $(OBJ)
	$(AR) $(ARFLAGS) $@ $(OBJ)

$(OBJ_DIR)/%.o: %.s
	$(CA) $(CPPFLAGS) $(CAFLAGS) -MD $(@:.o=.d) -o $@ $<

$(OBJ_DIR):
	$(MKDIR) $@

clean:
	$(RM) $(OBJ)
	$(RM) $(OBJ_DIR)

fclean: clean
	$(RM) $(NAME)
	
re: fclean all

test: $(NAME) $(TST_OUT)

%.out: %.c
	$(CC) $(CFLAGS) -Itest -Iinc $< $(LDFLAGS) -o $@
	$@ | tee $(patsubst test/test_%.out,test/%.log,$@) 1>/dev/null

cleantest:
	$(RM) $(TST_OUT)

fcleantest: cleantest
	$(RM)  $(patsubst test/test_%.out,test/%.log,$(TST_OUT))

retest: re fcleantest test

.PHONY: all clean fclean re test cleantest fcleantest retest
# **************************************************************************** #
