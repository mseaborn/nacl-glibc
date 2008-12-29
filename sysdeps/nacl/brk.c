
#include <errno.h>
#include <unistd.h>
#include <sysdep.h>

void *__curbrk = 0;
weak_alias (__curbrk, ___brk_addr)

__asm__(".global __gnacl_write; __gnacl_write = 0x11a0 ");
__asm__(".global __NaClSysBrk; __NaClSysBrk = 0x1280");

void *__NaClSysBrk(void *addr);
int __gnacl_write(int desc, void const *buf, size_t count);

int __brk (void *addr)
{
  __gnacl_write(1, "hi there!\n", 10);
  __curbrk = __NaClSysBrk(addr);
  return 0;
  //__set_errno (ENOMEM);
  //return -1;
}
weak_alias (__brk, brk)
