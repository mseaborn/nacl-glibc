#!/bin/bash

BUILDDIR=build
../tools_bin/linux/sdk/nacl-sdk/bin/nacl-gcc \
    -B$BUILDDIR/csu/ -L$BUILDDIR -static -Wl,-T,elf_i386.x \
    -g hellow.c -o hellow \
    -Wl,-print-map > hellow.map
