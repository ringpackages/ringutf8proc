# Character properties from the Unicode database

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	aChars = ["A", "z", "é", "5", "٣", "€", "+", "!", "ب", "日", "😀", " "]

	? unicodePadRight("Char", 6) + unicodePadRight("Code", 10) + unicodePadRight("Cat", 5) +
	  unicodePadRight("Category Name", 26) + "Width"
	? copy("-", 54)
	nCount = len(aChars)
	for x = 1 to nCount
		cChar = aChars[x]
		? unicodePadRight(cChar, 6) + unicodePadRight(unicodeToHex(cChar), 10) +
		  unicodePadRight(unicodeCategory(cChar), 5) +
		  unicodePadRight(unicodeCategoryName(cChar), 26) + unicodeCharWidth(cChar)
	next
	? ""

	# Classification functions accept a codepoint or a one character string
	? "unicodeIsLetter('ب')   : " + unicodeIsLetter("ب")
	? "unicodeIsDigit('٣')    : " + unicodeIsDigit("٣")
	? "unicodeIsNumber('½')   : " + unicodeIsNumber("½")
	? "unicodeIsPunct('¿')    : " + unicodeIsPunct("¿")
	? "unicodeIsSymbol('€')   : " + unicodeIsSymbol("€")
	? "unicodeIsSpace(0x3000) : " + unicodeIsSpace(0x3000)
	? "unicodeIsUpper('Ж')    : " + unicodeIsUpper("Ж")
	? "unicodeIsLower('ж')    : " + unicodeIsLower("ж")
	? "unicodeIsMark(0x301)   : " + unicodeIsMark(0x301)
	? ""

	# All the properties of one codepoint
	aInfo = unicodeCharInfo("Ä")
	nCount = len(aInfo)
	for x = 1 to nCount
		? unicodePadRight(aInfo[x][1], 20) + ": " + aInfo[x][2]
	next
