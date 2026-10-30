# Case mapping for all the scripts that have letter case

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	aTexts = [
		"hello world",
		"ÉCOLE ÉTÉ",
		"İstanbul ıi",
		"ΑΘΗΝΑ Σοφία",
		"москва",
		"ǆungla ǉubav",
		"don't stop"
	]

	nCount = len(aTexts)
	for x = 1 to nCount
		cText = aTexts[x]
		? "Text  : " + cText
		? "Upper : " + unicodeUpper(cText)
		? "Lower : " + unicodeLower(cText)
		? "Title : " + unicodeTitle(cText)
		? "Fold  : " + unicodeCaseFold(cText)
		? ""
	next

	# The Ring upper() and lower() functions change only the ASCII letters
	? "Ring upper()   : " + upper("élan vital")
	? "unicodeUpper() : " + unicodeUpper("élan vital")
	? ""

	# Case mapping of one codepoint
	? "utf8proc_toupper(0x3B1) = " + unicodeChar(utf8proc_toupper(0x3B1))
	? "utf8proc_tolower(0x410) = " + unicodeChar(utf8proc_tolower(0x410))
	? "utf8proc_totitle(0x1C6) = " + unicodeChar(utf8proc_totitle(0x1C6))
