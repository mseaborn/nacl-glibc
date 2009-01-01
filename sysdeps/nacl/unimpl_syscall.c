
#include <errno.h>
#include <unistd.h>
#include <string.h>

static void debug(const char *str)
{
  write(2, str, strlen(str));
}

int __unimplemented_syscall(const char *name)
{
  debug("syscall ");
  debug(name);
  debug("\n");
  errno = ENOSYS;
  return -1;
}
