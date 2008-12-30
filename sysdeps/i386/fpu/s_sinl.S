/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 *
 * Adapted for `long double' by Ulrich Drepper <drepper@cygnus.com>.
 */

#include <machine/asm.h>

RCSID("$NetBSD: $")

ENTRY(__sinl)
	fldt	4(%esp)
	fsin
	fnstsw	%ax
	testl	$0x400,%eax
	jnz	1f
	popl %ecx; nacljmp %ecx
	.align ALIGNARG(4)
1:	fldpi
	fadd	%st(0)
	fxch	%st(1)
2:	fprem1
	fnstsw	%ax
	testl	$0x400,%eax
	jnz	2b
	fstp	%st(1)
	fsin
	popl %ecx; nacljmp %ecx
END (__sinl)
weak_alias (__sinl, sinl)
