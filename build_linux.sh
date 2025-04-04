#!/bin/sh

gccwflags="-Wall -Wno-format-security"
gccflags="-s -fPIC -O3 -malign-double -fno-strict-aliasing -fvisibility=hidden -DUMKA_BUILD -DUMKA_EXT_LIBS $gccwflags"
sourcefiles="umka_api.c umka_common.c umka_compiler.c umka_const.c   umka_decl.c umka_expr.c
             umka_gen.c umka_ident.c  umka_lexer.c    umka_runtime.c umka_stmt.c umka_types.c umka_vm.c"

rm umka_linux -rf

cd src

rm -f *.o
rm -f *.a

gcc $gccflags -c $sourcefiles
gcc -s -shared -fPIC -static-libgcc *.o -o libumka.so -lm -ldl
ar rcs libumka_static_linux.a *.o

gcc $gccflags -c umka.c
gcc -s umka.o -o umka -static-libgcc -L$PWD -lm -lumka -Wl,-rpath,'$ORIGIN'

rm -f *.o

cd ..

mkdir umka_linux/examples/3dcam -p
mkdir umka_linux/examples/fractal -p
mkdir umka_linux/examples/lisp -p
mkdir umka_linux/examples/raytracer -p
mkdir umka_linux/doc
mkdir umka_linux/editors

mv src/libumka* src/umka umka_linux/
cp src/umka_api.h LICENSE umka_linux/

cp examples/* umka_linux/examples -r
cp doc/* umka_linux/doc
cp editors/* umka_linux/editors

echo Build finished
