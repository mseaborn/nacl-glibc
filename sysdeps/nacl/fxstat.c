
#include <errno.h>
#include <stddef.h>
#include <sys/stat.h>

#include <nacl_syscalls.h>


int __fxstat(int vers, int fd, struct stat *buf)
{
  int (*nacl_fstat)(int fd, struct stat *buf) =
    NACL_SYSCALL_ADDR(NACL_sys_fstat);
  int result = nacl_fstat(fd, buf);
  if (result < 0) {
    errno = -result;
    return -1;
  }
  return result;
}
hidden_def (__fxstat)
weak_alias (__fxstat, _fxstat)
