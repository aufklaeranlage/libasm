#define _GNU_SOURCE

#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
#include "test_macros.h"

#include "libasm.h"

static bool test_empty_base(void) {
  char str[] = "Hello", base[] = "";
  int ret = ft_atoi_base(str, base);
  printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
  return ret == 0;
}

static bool test_one_char_base(void) {
  char str[] = "000", base[] = "0";
  int ret = ft_atoi_base(str, base);
  printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
  return ret == 0;
}

static bool test_invalid_character_base(void) {
  int faults = 0;
  int ret;
  {
    char str[] = "1a", base[] = "0123456789+abcdef";
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 0;
  }
  {
    char str[] = "1a", base[] = "0123456789-abcdef";
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 0;
  }
  {
    char str[] = "1a", base[] = "0123456789 abcdef";
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 0;
  }
  {
    char str[] = "1a", base[] = "0123456789\tabcdef";
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 0;
  }
  {
    char str[] = "1a", base[] = "0123456789\nabcdef";
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 0;
  }
  {
    char str[] = "1a", base[] = "0123456789\vabcdef";
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 0;
  }
  {
    char str[] = "1a", base[] = "0123456789\fabcdef";
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 0;
  }
  {
    char str[] = "1a", base[] = "0123456789\rabcdef";
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 0;
  }
  {
    char str[] = "123", base[] = "0123";
    base[0] = (char)200;
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 0;
  }
  return faults == 0;
}

static bool test_duplicate_character_base(void) {
  char str[] = "aaa", base[] = "aabcdef";
  int ret = ft_atoi_base(str, base);
  printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
  return ret == 0;
}

static bool test_value_zero(void) {
  char str[] = "0", base[] = "01";
  int ret = ft_atoi_base(str, base);
  printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
  return ret == 0;
}

static bool test_value(void) {
  int ret, faults = 0;
  {
    char str[] = "1", base[] = "01";
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 1;
  }
  {
    char str[] = "9", base[] = "0123456789";
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 9;
  }
  {
    char str[] = "1A", base[] = "0123456789ABCDEF";
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 26;
  }
  return faults == 0;
}

static bool test_skip_ws(void) {
  char str[] = "     123", base[] = "0123456789";
  int ret = ft_atoi_base(str, base);
  printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
  return ret == 123;
}

static bool test_stop_after_non_base_char(void) {
  char str[] = "123ABC", base[] = "0123456789";
  int ret = ft_atoi_base(str, base);
  printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
  return ret == 123;
}

static bool test_deny_multiple_signs(void) {
  int ret, faults = 0;
  {
    char str[] = "--123", base[] = "0123456789";
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 0;
  }
  {
    char str[] = "-+123", base[] = "0123456789";
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 0;
  }
  {
    char str[] = "+-123", base[] = "0123456789";
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 0;
  }
  {
    char str[] = "++123", base[] = "0123456789";
    ret = ft_atoi_base(str, base);
    printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
    faults += ret != 0;
  }
  return faults == 0;
}

static bool test_negate(void) {
  char str[] = "-123", base[] = "0123456789";
  int ret = ft_atoi_base(str, base);
  printf("ft_atoi_base(): str: '%s', base: '%s', ret: %d\n", str, base, ret);
  return ret == -123;
}

int	main(void)
{
	TEST(test_empty_base);
	TEST(test_one_char_base);
	TEST(test_invalid_character_base);
  TEST(test_duplicate_character_base);
  TEST(test_value_zero);
  TEST(test_value);
  TEST(test_skip_ws);
  TEST(test_stop_after_non_base_char);
  TEST(test_negate);
  TEST(test_deny_multiple_signs);
}
