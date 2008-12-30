
#include <errno.h>
#include <unistd.h>
#include <sysdep.h>

void *__curbrk = 0;
weak_alias (__curbrk, ___brk_addr)

__asm__(".global __NaClSysBrk; __NaClSysBrk = 0x1280");

void *__NaClSysBrk(void *addr);

int __brk (void *addr)
{
  __curbrk = __NaClSysBrk(addr);
  return 0;
}
weak_alias (__brk, brk)
