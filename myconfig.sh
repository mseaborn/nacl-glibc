#!/bin/bash

set -e

BUILDDIR=build
mkdir -p $BUILDDIR
cd $BUILDDIR
../configure --prefix=/usr --host=i486-linux-gnu \
    CC="`pwd`/../../tools_bin/linux/sdk/nacl-sdk/bin/nacl-gcc" \
    CFLAGS="-march=i486 -pipe -fstrict-aliasing -O2 -g -mno-tls-direct-seg-refs" \
    --with-headers=`pwd`/../kernel-headers --enable-kernel=2.2.0
#    --disable-shared
