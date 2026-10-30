cls
setlocal enableextensions enabledelayedexpansion
call ../../language/build/locatevc.bat auto %1
cl /c %ringcflags% /DUTF8PROC_STATIC ring_utf8proc.c utf8proc/utf8proc.c -I"utf8proc" -I"..\..\language\include"
link %ringldflags% ring_utf8proc.obj utf8proc.obj ..\..\lib\ring.lib /DLL /OUT:..\..\bin\ring_utf8proc.dll /SUBSYSTEM:CONSOLE,"5.01" 
del *.obj
endlocal
