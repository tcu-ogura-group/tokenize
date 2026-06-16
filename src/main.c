/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: surayama <surayama@student.42tokyo.jp>     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/06/16 00:00:00 by surayama          #+#    #+#             */
/*   Updated: 2026/06/16 00:00:00 by surayama         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "tokenize.h"
#include "libft.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <readline/history.h>
#include <readline/readline.h>

#define PROMPT "tokenize$ "

static void	print_tokens(t_list *tokens)
{
	t_list	*current;

	write(STDOUT_FILENO, "[", 1);
	current = tokens;
	while (current)
	{
		write(STDOUT_FILENO, "\"", 1);
		ft_putstr_fd((char *)current->content, STDOUT_FILENO);
		write(STDOUT_FILENO, "\"", 1);
		if (current->next)
			ft_putstr_fd(", ", STDOUT_FILENO);
		current = current->next;
	}
	write(STDOUT_FILENO, "]\n", 2);
}

static char	*duplicate_input(const char *input)
{
	char	*copy;

	copy = ft_strdup(input);
	return (copy);
}

int	main(void)
{
	char	*input;
	char	*input_dup;
	t_list	*tokens;

	while (1)
	{
		input = readline(PROMPT);
		if (!input)
		{
			write(STDOUT_FILENO, "exit\n", 5);
			break ;
		}
		if (is_blank_line(input))
		{
			free(input);
			continue ;
		}
		add_history(input);
		input_dup = duplicate_input(input);
		free(input);
		if (!input_dup)
			continue ;
		tokens = tokenize(input_dup);
		if (!tokens)
		{
			ft_putstr_fd("tokenize: error\n", STDERR_FILENO);
			continue ;
		}
		print_tokens(tokens);
		ft_lstclear(&tokens, free);
	}
	rl_clear_history();
	return (0);
}
