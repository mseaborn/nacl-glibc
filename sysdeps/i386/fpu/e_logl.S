/*
 * Written by J.T. Conklin <jtc@netbsd.org>.
 * Public domain.
 *
 * Adapted for `long double' by Ulrich Drepper <drepper@cygnus.com>.
 */

#include <machine/asm.h>

RCSID("$NetBSD: $")


#ifdef __ELF__
	.section .rodata
#else
	.text
#endif
	.align ALIGNARG(4)
	ASM_TYPE_DIRECTIVE(one,@object)
one:	.double 1.0
	ASM_SIZE_DIRECTIVE(one)
	/* It is not important that this constant is precise.  It is only
	   a value which is known to be on the safe side for using the
	   fyl2xp1 instruction.  */
	ASM_TYPE_DIRECTIVE(limit,@object)
limit:	.double 0.29
	ASM_SIZE_DIRECTIVE(limit)


#ifdef PIC
#define MO(op) op##@GOTOFF(%edx)
#else
#define MO(op) op
#endif

	.text
ENTRY(__ieee754_logl)
	fldln2			// log(2)
	fldt	4(%esp)		// x : log(2)
	fxam
	fnstsw
#ifdef PIC
	LOAD_PIC_REG (dx)
#endif
	fld	%st		// x : x : log(2)
	sahf
	jc	3f		// in case x is NaN or +-Inf
4:	fsubl	MO(one)		// x-1 : x : log(2)
	fld	%st		// x-1 : x-1 : x : log(2)
	fabs			// |x-1| : x-1 : x : log(2)
	fcompl	MO(limit)	// x-1 : x : log(2)
	fnstsw			// x-1 : x : log(2)
	andb	$0x45, %ah
	jz	2f
	fstp	%st(1)		// x-1 : log(2)
	fyl2xp1			// log(x)
	popl %ecx; nacljmp %ecx

2:	fstp	%st(0)		// x : log(2)
	fyl2x			// log(x)
	popl %ecx; nacljmp %ecx

3:	jp	4b		// in case x is +-Inf
	fstp	%st(1)
	fstp	%st(1)
	popl %ecx; nacljmp %ecx
END (__ieee754_logl)
