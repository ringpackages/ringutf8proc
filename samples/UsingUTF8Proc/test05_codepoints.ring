# Converting between strings and codepoints

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	cText = "Aé€😀"
	? "Text       : " + cText
	? "Bytes      : " + len(cText)
	? "Codepoints : " + unicodeLength(cText)
	? "Hex        : " + unicodeToHex(cText)
	? ""

	aCodes = unicodeCodepoints(cText)
	nCount = len(aCodes)
	for x = 1 to nCount
		cChar = unicodeChar(aCodes[x])
		? "  " + cChar + "  code: " + aCodes[x] + "  bytes: " + len(cChar)
	next
	? ""

	# Build a string from codepoints
	? "From codepoints : " + unicodeFromCodepoints([0x52, 0x69, 0x6E, 0x67, 0x20, 0x2764])
	? "Code of the Euro sign : " + unicodeCode("€")
	? ""

	# Walk a string using utf8proc_iterate() (byte positions start from 1)
	nPos = 1
	while True
		aResult = utf8proc_iterate(cText, nPos)
		if aResult[2] <= 0
			exit
		ok
		? "Position " + nPos + " : U+" + upper(hex(aResult[1])) + " (" + aResult[2] + " bytes)"
		nPos += aResult[2]
	end
