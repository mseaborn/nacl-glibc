
#include <errno.h>
#include <unistd.h>
#include <sysdep.h>

#include <nacl_syscalls.h>


void *__curbrk = 0;
weak_alias (__curbrk, ___brk_addr)

int __brk (void *addr)
{
  void *(*__NaClSysBrk)(void *addr) = NACL_SYSCALL_ADDR(NACL_sys_sysbrk);
  __curbrk = __NaClSysBrk(addr);
  return 0;
}
weak_alias (__brk, brk)
