#!/bin/bash

# This script is a shortcut for building libc.so.
# It's faster than running make on glibc.

set -e

BUILD=build

../tools_bin/linux/sdk/nacl-sdk/bin/nacl-gcc \
    -nostdlib -nostartfiles -r -o $BUILD/libc_pic.os \
    -Wl,-d -Wl,--whole-archive $BUILD/libc_pic.a \
    -Wl,-Map,$BUILD/libc_pic.os.map

../tools_bin/linux/sdk/nacl-sdk/bin/nacl-gcc   -shared -static-libgcc -Wl,-O1  -Wl,-z,defs -Wl,-dynamic-linker=/lib/ld-linux.so.2  -B$BUILD/csu/  -Wl,--version-script=$BUILD/libc.map -Wl,-soname=libc.so.6 -Wl,-z,relro -Wl,--hash-style=both -nostdlib -nostartfiles -e __libc_main -L$BUILD -L$BUILD/math -L$BUILD/elf -L$BUILD/dlfcn -L$BUILD/nss -L$BUILD/nis -L$BUILD/rt -L$BUILD/resolv -L$BUILD/crypt -L$BUILD/nptl -Wl,-rpath-link=$BUILD:$BUILD/math:$BUILD/elf:$BUILD/dlfcn:$BUILD/nss:$BUILD/nis:$BUILD/rt:$BUILD/resolv:$BUILD/crypt:$BUILD/nptl -o $BUILD/libc.so $BUILD/csu/abi-note.o $BUILD/elf/soinit.os $BUILD/libc_pic.os $BUILD/elf/sofini.os $BUILD/elf/interp.os $BUILD/elf/ld.so -lgcc -Lld \
    -Wl,-Map,$BUILD/libc.so.map
