#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "test_macros.h"

#include "libasm.h"

static bool test_zero(void) {
  t_list  *head = NULL;
  int ret = ft_list_size(head), expect = 0;
  fprintf(stdout, "expected: %d, received: %d\n", expect, ret);
  return ret == expect;
}

static bool test_one(void) {
  t_list  *head = NULL;
  ft_list_push_front(&head, NULL);
  int ret = ft_list_size(head), expect = 1;
  fprintf(stdout, "expected: %d, received: %d\n", expect, ret);
  return ret == expect;
}

static bool test_five(void) {
  t_list  *head = NULL;
  ft_list_push_front(&head, NULL);
  ft_list_push_front(&head, NULL);
  ft_list_push_front(&head, NULL);
  ft_list_push_front(&head, NULL);
  ft_list_push_front(&head, NULL);
  int ret = ft_list_size(head), expect = 5;
  fprintf(stdout, "expected: %d, received: %d\n", expect, ret);
  return ret == expect;
}

int main() {
	TEST(test_zero);
  TEST(test_one);
  TEST(test_five);
}
