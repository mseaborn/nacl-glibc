#!/bin/bash

set -e

# Since we are taking Linux glibc as a starting point we need the
# Linux kernel headers.  In the long term we will need Linux's errno
# numbers, but probably nothing more.
rm -rf kernel-headers
mkdir kernel-headers
cp -a /usr/include/asm /usr/include/asm-generic /usr/include/linux \
    kernel-headers/

BUILDDIR=build
mkdir -p $BUILDDIR
PREFIX=$(cd .. && pwd)/install
cd $BUILDDIR
../configure --prefix=$PREFIX --host=i486-linux-gnu \
    CC="`pwd`/../../tools_bin/linux/sdk/nacl-sdk/bin/nacl-gcc" \
    CFLAGS="-march=i486 -pipe -fstrict-aliasing -O2 -g -mno-tls-direct-seg-refs" \
    --with-headers=`pwd`/../kernel-headers --enable-kernel=2.2.0
#    --disable-shared
