#include <sysdep.h>

	.text
ENTRY(__fabsl)
	fldt	4(%esp)
	fabs
	popl %ecx; nacljmp %ecx
END(__fabsl)
weak_alias (__fabsl, fabsl)
