# Library and Unicode version information

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	? "utf8proc version : " + unicodeLibVersion()
	? "Unicode version  : " + unicodeVersion()
	? "Header version   : " + UTF8PROC_VERSION_MAJOR + "." + UTF8PROC_VERSION_MINOR + "." + UTF8PROC_VERSION_PATCH
