#!/bin/bash

# This script is a shortcut for building the dynamic linker.
# It's faster than running make on glibc.

cd build
../../tools_bin/linux/sdk/nacl-sdk/bin/nacl-gcc \
    -nostdlib -nostartfiles -shared \
    -o elf/ld.so			\
    -Wl,-z,relro -Wl,--hash-style=both -Wl,-z,defs 	\
    elf/librtld.os -Wl,--version-script=ld.map		\
    -Wl,-Map,elf/ld.so.map				\
    -Wl,-soname=ld-linux.so.2 -T ../elf_i386.xs
