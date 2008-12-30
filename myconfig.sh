#!/bin/bash

set -e

mkdir -p build
cd build
../configure --prefix=/usr --host=i486-linux-gnu \
    CC="`pwd`/../../tools_bin/linux/sdk/nacl-sdk/bin/nacl-gcc" \
    CFLAGS="-march=i486 -pipe -fstrict-aliasing -O2 -g -mno-tls-direct-seg-refs" \
    --with-headers=`pwd`/../kernel-headers \
    --disable-shared
