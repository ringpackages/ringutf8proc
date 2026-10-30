# Trim, find and replace by grapheme clusters

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	# unicodeTrim() removes all the Unicode white space (Ring trim() removes ASCII spaces only)
	cIdeographicSpace = unicodeChar(0x3000)
	cNoBreakSpace = unicodeChar(0xA0)
	cText = cIdeographicSpace + " " + char(9) + "Hello World" + cNoBreakSpace + nl
	? "Ring trim()          : [" + trim(cText) + "]"
	? "unicodeTrim()        : [" + unicodeTrim(cText) + "]"
	? "unicodeTrimLeft()    : [" + unicodeTrimLeft("   left and right   ") + "]"
	? "unicodeTrimRight()   : [" + unicodeTrimRight("   left and right   ") + "]"
	? ""

	# unicodeFind() returns the position in user-perceived characters
	cText = "👨‍👩‍👧 family and 🇪🇬 flag"
	? "Text : " + cText
	? "unicodeFind('flag')      : " + unicodeFind(cText, "flag")
	? "unicodeFind('🇪🇬')        : " + unicodeFind(cText, "🇪🇬")
	? "unicodeFind('👩')        : " + unicodeFind(cText, "👩") + "  (part of the family emoji, not a character)"
	? "Ring substr() byte index : " + substr(cText, "flag")
	? ""

	# A match must be a whole character: "e" is not found inside "e" + combining accent
	cAccented = "Cafe" + unicodeChar(0x301) + " menu"
	? "Text : " + cAccented
	? "unicodeFind('e')     : " + unicodeFind(cAccented, "e")
	? "unicodeReplace(e, E) : " + unicodeReplace(cAccented, "e", "E")
	? ""

	# unicodeReplace() replaces all the matches, and is safe for strings that contain char(0)
	? unicodeReplace("one, two, three", ", ", " → ")
	cData = "field1" + char(0) + "field2" + char(0) + "field3"
	? unicodeReplace(cData, char(0), " | ")
	? ""

	# The UnicodeString class
	oText = new UnicodeString("   Ring is a practical language   ")
	? "[" + oText.trimSpaces().replaceText("practical", "practical, general-purpose").value() + "]"
	? "findText('language') : " + oText.findText("language")
