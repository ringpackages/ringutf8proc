# Grapheme clusters: what the user sees as one character

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	aTexts = [
		"Ring",
		"e" + unicodeChar(0x301) + "te" + unicodeChar(0x301),
		"👨‍👩‍👧‍👦",
		"🇪🇬🇯🇵🇧🇷",
		"👍🏽 ok",
		"नमस्ते",
		"한국어"
	]

	nCount = len(aTexts)
	for x = 1 to nCount
		cText = aTexts[x]
		? "Text: " + cText
		? "  Bytes: " + len(cText) + "  Codepoints: " + unicodeLength(cText) +
		  "  Graphemes: " + unicodeGraphemeCount(cText)
		aGraphemes = unicodeGraphemes(cText)
		cLine = "  Parts: "
		nParts = len(aGraphemes)
		for y = 1 to nParts
			cLine += "[" + aGraphemes[y] + "]"
		next
		? cLine
		? "  Reversed: " + unicodeReverse(cText)
	next
	? ""

	# Grapheme-aware substrings
	cText = "🇪🇬 Egypt 🇯🇵 Japan"
	? "Text             : " + cText
	? "unicodeLeft(7)    : " + unicodeLeft(cText, 7)
	? "unicodeRight(5)   : " + unicodeRight(cText, 5)
	? "unicodeSubStr(9,1): " + unicodeSubStr(cText, 9, 1)
