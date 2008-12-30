/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

RCSID("$NetBSD: s_cos.S,v 1.5 1995/05/08 23:54:00 jtc Exp $")

ENTRY(__cos)
	fldl	4(%esp)
	fcos
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
	fcos
	popl %ecx; nacljmp %ecx
END (__cos)
weak_alias (__cos, cos)
