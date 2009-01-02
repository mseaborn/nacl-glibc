
#include <errno.h>
#include <unistd.h>
#include <sysdep.h>

__asm__(".global __gnacl_write; __gnacl_write = 0x11a0 ");

int __gnacl_write(int desc, void const *buf, size_t count);

int __write(int desc, void const *buf, size_t count)
{
  int result = __gnacl_write(desc, buf, count);
  if (result < 0)
    errno = -result;
  return result;
}
libc_hidden_def (__write)
weak_alias (__write, write)
strong_alias (__write, __libc_write)
strong_alias (__write, __write_nocancel)
