clang -c -fpic -O2 -DUTF8PROC_STATIC ring_utf8proc.c utf8proc/utf8proc.c -I utf8proc -I $PWD/../../language/include
clang -dynamiclib -o $PWD/../../lib/libring_utf8proc.dylib ring_utf8proc.o utf8proc.o -L $PWD/../../lib -lring
rm -f *.o
