
#include <sys/types.h>
#include <sys/mman.h>
#include <errno.h>


int __mprotect (__ptr_t addr, size_t len, int prot)
{
  /* NaCl doesn't implement mprotect() yet, but ld.so expects it to
     return successfully. */
  return 0;
}
weak_alias (__mprotect, mprotect)
strong_alias (__mprotect, __mprotect_nocancel)
