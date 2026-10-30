if isWindows()
	LoadLib("ring_utf8proc.dll")
but ismacosx()
	LoadLib("libring_utf8proc.dylib")
else
	LoadLib("libring_utf8proc.so")
ok

load "ring_utf8proc.rh"
