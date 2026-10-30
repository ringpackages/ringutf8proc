gcc -c -fpic -O2 -DUTF8PROC_STATIC ring_utf8proc.c utf8proc/utf8proc.c -I utf8proc -I $PWD/../../language/include
gcc -shared -o $PWD/../../lib/libring_utf8proc.so ring_utf8proc.o utf8proc.o -L $PWD/../../lib -lring
rm -f *.o
