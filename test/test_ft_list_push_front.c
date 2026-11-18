#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "test_macros.h"

#include "libasm.h"

static void pnode(t_list *node) {
  if (node == NULL)
    fprintf(stdout, "Invalid Node\n");
  else
    fprintf(stdout, "addr: %p, data: %p, next: %p\n", node, node->data, node->next);
}

static bool test_freeable(void) {
  // More of a runtime check, should complain about invalid address on issue
  t_list  *head = NULL;
  char    str[] = "Hello, World!";
  ft_list_push_front(&head, str);
  pnode(head);
  free(head);
  return 1;
}

static bool test_head_set(void) {
  t_list  *head = NULL;
  char    str[] = "Hello, World!";
  ft_list_push_front(&head, str);
  pnode(head);
  return (head != NULL && head->data == str);
}

static bool test_two_nodes(void) {
  t_list  *head = NULL, *second = NULL;
  char    str[] = "Hello, World!";
  ft_list_push_front(&head, str);
  second = head;
  ft_list_push_front(&head, str);
  fprintf(stdout, "head: ");
  pnode(head);
  fprintf(stdout, "second: ");
  pnode(second);
  return (head != NULL && head->data == str && head->next == second && second != NULL && second != head && second->data == str);
}

int main() {
	TEST(test_freeable);
  TEST(test_head_set);
  TEST(test_two_nodes);
}
