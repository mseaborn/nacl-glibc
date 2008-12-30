#include <sysdep.h>

	.text
ENTRY(__fabs)
	fldl	4(%esp)
	fabs
	popl %ecx; nacljmp %ecx
END(__fabs)
weak_alias (__fabs, fabs)
