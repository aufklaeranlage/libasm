# **************************************************************************** #
NAME := libasm.l

# * DIRECTORIES ************************************************************** #
SRC_DIR := src
OBJ_DIR := obj

# * FILES ******************************************************************** #
SRC :=
vpath %.s $(SRC_DIR)/
SRC += ft_strlen.s
SRC += ft_strcpy.s
SRC += ft_strcmp.s
SRC += ft_write.s

OBJ := $(SRC:.s=.o)
OBJ := $(addprefix $(OBJ_DIR)/, $(OBJ))

DEP := $(OBJ:.o=.d)

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

LDFLAGS :=
LDFLAGS += -L. -l:libasm.l

ifdef DEBUG
	CAFLAGS += -g
	CAFLAGS += -O0
else
# Minimize branch offsets, and signed immediate bytes, by overriding size specification unless strict is used
	CAFLAGS += -Oxv
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

exec:
	$(CC) $(CPPFLAGS) main.c $(LDFLAGS)

re: fclean all

.PHONY: all clean fclean re
# **************************************************************************** #
