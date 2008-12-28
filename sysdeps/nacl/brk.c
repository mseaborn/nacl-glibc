
#include <errno.h>
#include <unistd.h>
#include <sysdep.h>

void *__curbrk = 0;
weak_alias (__curbrk, ___brk_addr)

int __NaClSysBrk(int);
int __nacl_write(int desc, void const *buf, size_t count);
// __attribute__((weak));

int __brk (void *addr)
{
  __nacl_write(1, "hi there!\n", 10);
  __curbrk = __NaClSysBrk(addr);
  return 0;
  //__set_errno (ENOMEM);
  //return -1;
}
weak_alias (__brk, brk)
