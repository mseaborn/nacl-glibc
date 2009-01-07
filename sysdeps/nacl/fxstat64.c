
#include <errno.h>
#include <stddef.h>
#include <sys/stat.h>

#include <nacl_syscalls.h>


int __fxstat64(int vers, int fd, struct stat64 *buf)
{
  int (*nacl_fstat)(int fd, struct stat64 *buf) =
    NACL_SYSCALL_ADDR(NACL_sys_fstat);
  int result = nacl_fstat(fd, buf);
  if (result < 0) {
    errno = -result;
    return -1;
  }
  return result;
}
hidden_def (__fxstat64)
