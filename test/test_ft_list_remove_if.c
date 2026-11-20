#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "test_macros.h"

#include "libasm.h"

static void pnode_str(t_list *node) {
  if (node == NULL)
    fprintf(stdout, "Invalid Node\n");
  else
    fprintf(stdout, "addr: %p, data: %s, next: %p\n", node, (char *)node->data, node->next);
}

static void pnode_int(t_list *node) {
  if (node == NULL)
    fprintf(stdout, "Invalid Node\n");
  else
    fprintf(stdout, "addr: %p, data: %d, next: %p\n", node, *(int *)node->data, node->next);
}

static bool test_remove_strcmp(void) {
  t_list *head = NULL;
  char *str[] = {
    "Hello",
    "World",
    "Alpha",
    "Zetta"
  };
  for (int i = 0; i < 4; i++) {
    ft_list_push_front(&head, str[i]);
  }
  ft_list_remove_if(&head, "Alpha", strcmp, NULL);
  for (t_list *node = head; node != NULL; node = node->next) {
    pnode_str(node);
  }
  return ft_list_size(head) == 3;
}

static int intcmp(void *d1, void *d2) {
  return (*(int *)d1 - *(int *)d2);
}

static bool test_remove_intcmp(void) {
  t_list *head = NULL;
  int ref = 2;
  int *arr[4];
  for (int i = 0; i < 4; i++) {
    arr[i] = malloc(sizeof(int));
    *arr[i] = i;
    ft_list_push_front(&head, arr[i]);
  }
  ft_list_remove_if(&head, &ref, intcmp, free);
  for (t_list *node = head; node != NULL; node = node->next) {
    pnode_int(node);
  }
  return ft_list_size(head) == 3;
}

int main() {
	TEST(test_remove_strcmp);
	TEST(test_remove_intcmp);
}
