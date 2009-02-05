#!/bin/bash

BUILDDIR=build
DEST=hellow-dyn
../tools_bin/linux/sdk/nacl-sdk/bin/nacl-gcc \
    -B$BUILDDIR/csu/ -L$BUILDDIR -Lld \
    $BUILDDIR/elf/ld.so $BUILDDIR/libc_nonshared.a \
    -g hellow.c -o $DEST \
    -Wl,-Map,$DEST.map
