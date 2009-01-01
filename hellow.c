
#include <stdio.h>

int main()
{
  write(1, "Hello (via write())\n", 20);
  printf("Hello world (%s)\n", "via printf()");
  open("file", 0);
  return 0;
}
