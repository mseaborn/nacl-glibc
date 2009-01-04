
#include <errno.h>
#include <unistd.h>
#include <sysdep.h>

void *__curbrk = 0;
weak_alias (__curbrk, ___brk_addr)

int __brk (void *addr)
{
  void *(*__NaClSysBrk)(void *addr) = 0x1280;
  __curbrk = __NaClSysBrk(addr);
  return 0;
}
weak_alias (__brk, brk)
