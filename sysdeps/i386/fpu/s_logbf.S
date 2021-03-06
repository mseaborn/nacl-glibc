/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 */

#include <machine/asm.h>

RCSID("$NetBSD: s_logbf.S,v 1.3 1995/05/09 00:15:12 jtc Exp $")

ENTRY(__logbf)
	flds	4(%esp)
	fxtract
	fstp	%st
	popl %ecx; nacljmp %ecx
END (__logbf)
weak_alias (__logbf, logbf)
