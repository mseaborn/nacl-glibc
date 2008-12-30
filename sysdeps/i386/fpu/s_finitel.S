/*
 * Written by Joe Keane <jgk@jgk.org>.
 */

#include <machine/asm.h>

ENTRY(__finitel)
	movl	12(%esp),%eax
	orl	$0xffff8000, %eax
	incl	%eax
	shrl	$31, %eax
	popl %ecx; nacljmp %ecx
END (__finitel)
weak_alias (__finitel, finitel)
hidden_def (__finitel)
