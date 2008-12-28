#!/bin/bash

set -e

mkdir -p build4
cd build4
../configure --prefix=/usr --host=i486-linux-gnu \
    CC="`pwd`/../../tools_bin/linux/sdk/nacl-sdk/bin/nacl-gcc" \
    CFLAGS="-march=i486 -pipe -fstrict-aliasing -O2" \
    --with-headers=`pwd`/../kernel-headers \
    --disable-shared
