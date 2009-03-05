#!/bin/bash

# This script is a shortcut for building libc.so, the dynamic linker,
# and some other libraries.
# It's faster than running make on glibc.

set -e

BUILD=build

echo - ld.so
../tools_bin/linux/sdk/nacl-sdk/bin/nacl-gcc \
    -nostdlib -nostartfiles -shared \
    -o $BUILD/elf/ld.so			\
    -Wl,-z,relro -Wl,--hash-style=both -Wl,-z,defs 	\
    $BUILD/elf/librtld.os -Wl,--version-script=$BUILD/ld.map		\
    -Wl,-Map,$BUILD/elf/ld.so.map				\
    -Wl,-soname=ld-linux.so.2 -Lld

echo - libc_pic.os
../tools_bin/linux/sdk/nacl-sdk/bin/nacl-gcc \
    -nostdlib -nostartfiles -r -o $BUILD/libc_pic.os \
    -Wl,-d -Wl,--whole-archive $BUILD/libc_pic.a \
    -Wl,-Map,$BUILD/libc_pic.os.map

echo - libc.so
../tools_bin/linux/sdk/nacl-sdk/bin/nacl-gcc   -shared -static-libgcc -Wl,-O1  -Wl,-z,defs -Wl,-dynamic-linker=/lib/ld-linux.so.2  -B$BUILD/csu/  -Wl,--version-script=$BUILD/libc.map -Wl,-soname=libc.so.6 -Wl,-z,relro -Wl,--hash-style=both -nostdlib -nostartfiles -e __libc_main -L$BUILD -L$BUILD/math -L$BUILD/elf -L$BUILD/dlfcn -L$BUILD/nss -L$BUILD/nis -L$BUILD/rt -L$BUILD/resolv -L$BUILD/crypt -L$BUILD/nptl -Wl,-rpath-link=$BUILD:$BUILD/math:$BUILD/elf:$BUILD/dlfcn:$BUILD/nss:$BUILD/nis:$BUILD/rt:$BUILD/resolv:$BUILD/crypt:$BUILD/nptl -o $BUILD/libc.so $BUILD/csu/abi-note.o $BUILD/elf/soinit.os $BUILD/libc_pic.os $BUILD/elf/sofini.os $BUILD/elf/interp.os $BUILD/elf/ld.so -lgcc -Lld \
    -Wl,-Map,$BUILD/libc.so.map

echo - libdl.so
../tools_bin/linux/sdk/nacl-sdk/bin/nacl-gcc -L$BUILD/../ld   -shared -static-libgcc -Wl,-O1  -Wl,-z,defs -Wl,-dynamic-linker=/work/nacl/2/googleclient/native_client/install/lib/ld-linux.so.2  -B$BUILD/csu/  -Wl,--version-script=$BUILD/libdl.map -Wl,-soname=libdl.so.2 -Wl,-z,relro -Wl,--hash-style=both  -L$BUILD -L$BUILD/math -L$BUILD/elf -L$BUILD/dlfcn -L$BUILD/nss -L$BUILD/nis -L$BUILD/rt -L$BUILD/resolv -L$BUILD/crypt -L$BUILD/nptl -Wl,-rpath-link=$BUILD:$BUILD/math:$BUILD/elf:$BUILD/dlfcn:$BUILD/nss:$BUILD/nis:$BUILD/rt:$BUILD/resolv:$BUILD/crypt:$BUILD/nptl -o $BUILD/dlfcn/libdl.so $BUILD/csu/abi-note.o -Wl,--whole-archive $BUILD/dlfcn/libdl_pic.a -Wl,--no-whole-archive $BUILD/elf/interp.os $BUILD/libc.so $BUILD/libc_nonshared.a $BUILD/elf/ld.so  \
    -Wl,-Map,$BUILD/dlfcn/libdl.so.map

echo - libmemusage.so
../tools_bin/linux/sdk/nacl-sdk/bin/nacl-gcc -L$BUILD/../ld   -shared -static-libgcc -Wl,-O1  -Wl,-z,defs -Wl,-dynamic-linker=/work/nacl/2/googleclient/native_client/install/lib/ld-linux.so.2  -B$BUILD/csu/   -Wl,-soname=libmemusage.so -Wl,-z,relro -Wl,--hash-style=both  -L$BUILD -L$BUILD/math -L$BUILD/elf -L$BUILD/dlfcn -L$BUILD/nss -L$BUILD/nis -L$BUILD/rt -L$BUILD/resolv -L$BUILD/crypt -L$BUILD/nptl -Wl,-rpath-link=$BUILD:$BUILD/math:$BUILD/elf:$BUILD/dlfcn:$BUILD/nss:$BUILD/nis:$BUILD/rt:$BUILD/resolv:$BUILD/crypt:$BUILD/nptl -o $BUILD/malloc/libmemusage.so $BUILD/csu/abi-note.o -Wl,--whole-archive $BUILD/malloc/libmemusage_pic.a -Wl,--no-whole-archive $BUILD/elf/interp.os $BUILD/dlfcn/libdl.so $BUILD/elf/ld.so  \
    -Wl,-Map,$BUILD/malloc/libmemusage.so.map

echo - libpthread.so
../tools_bin/linux/sdk/nacl-sdk/bin/nacl-gcc -L$BUILD/../ld   -shared -static-libgcc -Wl,-O1  -Wl,-z,defs -Wl,-dynamic-linker=/work/nacl/3/googleclient/native_client/install/lib/ld-linux.so.2 -B$BUILD/nptl/ -B$BUILD/csu/ -B$BUILD/nptl/ -Wl,--version-script=$BUILD/libpthread.map -Wl,-soname=libpthread.so.0 -Wl,-z,relro -Wl,--hash-style=both -Wl,--enable-new-dtags,-z,nodelete,-z,initfirst -e __nptl_main -L$BUILD -L$BUILD/math -L$BUILD/elf -L$BUILD/dlfcn -L$BUILD/nss -L$BUILD/nis -L$BUILD/rt -L$BUILD/resolv -L$BUILD/crypt -L$BUILD/nptl -Wl,-rpath-link=$BUILD:$BUILD/math:$BUILD/elf:$BUILD/dlfcn:$BUILD/nss:$BUILD/nis:$BUILD/rt:$BUILD/resolv:$BUILD/crypt:$BUILD/nptl -o $BUILD/nptl/libpthread.so $BUILD/csu/abi-note.o -Wl,--whole-archive $BUILD/nptl/libpthread_pic.a -Wl,--no-whole-archive $BUILD/elf/interp.os $BUILD/libc.so $BUILD/libc_nonshared.a $BUILD/elf/ld.so 
