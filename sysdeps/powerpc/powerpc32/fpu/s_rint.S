/* Round to int floating-point values.  PowerPC32 version.
   Copyright (C) 2004, 2006 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 1 Franklin Street, Fifth Floor, Boston MA
   02110-1301 USA.  */

/* This has been coded in assembler because GCC makes such a mess of it
   when it's coded in C.  */

#include <sysdep.h>
#include <math_ldbl_opt.h>

	.section	.rodata.cst4,"aM",@progbits,4
	.align	2
.LC0:	/* 2**52 */
	.long 0x59800000

	.section	".text"
ENTRY (__rint)
#ifdef SHARED
	mflr	r11
	cfi_register(lr,r11)
# ifdef HAVE_ASM_PPC_REL16
	bcl	20,31,1f
1:	mflr	r9
	addis	r9,r9,.LC0-1b@ha
	lfs	fp13,.LC0-1b@l(r9)
# else
	bl	_GLOBAL_OFFSET_TABLE_@local-4
	mflr	r10
	lwz	r9,.LC0@got(10)
	lfs	fp13,0(r9)
# endif
	mtlr	r11
	cfi_same_value (lr)
#else
	lis	r9,.LC0@ha
	lfs	fp13,.LC0@l(r9)
#endif
	fabs	fp0,fp1
	fsub	fp12,fp13,fp13	/* generate 0.0  */
	fcmpu	cr7,fp0,fp13	/* if (fabs(x) > TWO52)  */
	fcmpu	cr6,fp1,fp12	/* if (x > 0.0)  */
	bnllr-	cr7
	bng-	cr6,.L4
	fadd	fp1,fp1,fp13	/* x+= TWO52;  */
	fsub	fp1,fp1,fp13	/* x-= TWO52;  */
	fabs	fp1,fp1		/* if (x == 0.0)  */
	blr			/* x = 0.0; */
.L4:
	bnllr-	cr6		/* if (x < 0.0)  */
	fsub	fp1,fp1,fp13	/* x-= TWO52;  */
	fadd	fp1,fp1,fp13	/* x+= TWO52;  */
	fnabs	fp1,fp1		/* if (x == 0.0)  */
	blr			/* x = -0.0; */
	END (__rint)

weak_alias (__rint, rint)

#ifdef NO_LONG_DOUBLE
weak_alias (__rint, rintl)
strong_alias (__rint, __rintl)
#endif
#if LONG_DOUBLE_COMPAT(libm, GLIBC_2_0)
compat_symbol (libm, __rint, rintl, GLIBC_2_0)
#endif
