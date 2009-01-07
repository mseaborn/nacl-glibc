
#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <sysdep.h>
#include <unistd.h>

#include <nacl_syscalls.h>


int __open(const char *filename, int flags, ...)
{
  int (*nacl_open)(char const *pathname, int flags, int mode) = 
    NACL_SYSCALL_ADDR(NACL_sys_open);
  int mode = 0;
  if(flags & O_CREAT) {
    va_list arg;
    va_start(arg, flags);
    mode = va_arg(arg, int);
    va_end(arg);
  }
  int result = nacl_open(filename, flags, mode);
  if (result < 0)
    errno = -result;
  return result;
}
libc_hidden_def (__open)
weak_alias (__open, open)
strong_alias (__open, __libc_open)
strong_alias (__open, __open_nocancel)
