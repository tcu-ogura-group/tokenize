# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: surayama <surayama@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/06/16 00:00:00 by surayama          #+#    #+#              #
#    Updated: 2026/06/16 00:00:00 by surayama         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME		:=	tokenize

CC			:=	cc
CFLAGS		:=	-Wall -Wextra -Werror -Iincludes -Ilibft

# readline (macOS / Homebrew aware)
UNAME_S		:=	$(shell uname -s)
ifeq ($(UNAME_S),Darwin)
  BREW_PREFIX	:=	$(shell brew --prefix readline 2>/dev/null)
  ifneq ($(BREW_PREFIX),)
    CFLAGS		+=	-I$(BREW_PREFIX)/include
    LDFLAGS		+=	-L$(BREW_PREFIX)/lib
  endif
endif

LDLIBS		:=	-lreadline

SRCDIR		:=	src
OBJDIR		:=	obj
LIBFT_DIR	:=	libft
LIBFT_A		:=	$(LIBFT_DIR)/libft.a

SRCS		:=	src/main.c \
				src/tokenize/tokenize.c \
				src/tokenize/is_specific.c \
				src/tokenize/state/in_normal.c \
				src/tokenize/state/in_normal/by_last.c \
				src/tokenize/state/in_normal/by_space.c \
				src/tokenize/state/in_normal/by_operator.c \
				src/tokenize/state/in_normal/by_quote.c \
				src/tokenize/state/in_normal/by_parenthesis.c \
				src/tokenize/state/in_double_quote.c \
				src/tokenize/state/in_single_quote.c \
				src/tokenize/state/in_operator.c \
				src/tokenize/state/on_success.c \
				src/tokenize/state/on_error.c \
				src/tokenize/store/free_store.c \
				src/tokenize/store/push_token.c \
				src/tokenize/store/add_buffer.c

OBJS		:=	$(SRCS:$(SRCDIR)/%.c=$(OBJDIR)/%.o)

all: $(NAME)

$(NAME): $(LIBFT_A) $(OBJS)
	@$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) -o $@ $(LIBFT_A) $(LDLIBS)
	@echo "Built $(NAME)"

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -c -o $@ $<

$(LIBFT_A):
	@$(MAKE) -C $(LIBFT_DIR)

clean:
	@$(MAKE) -C $(LIBFT_DIR) clean
	@rm -rf $(OBJDIR)

fclean: clean
	@$(MAKE) -C $(LIBFT_DIR) fclean
	@rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re
