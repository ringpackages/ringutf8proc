# Unicode normalization: the same text can be stored using different codepoints

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	# "é" as one codepoint (U+00E9) and as "e" + combining acute accent (U+0301)
	cComposed = unicodeChar(0xE9)
	cDecomposed = "e" + unicodeChar(0x301)

	? "Composed   : " + cComposed + "  " + unicodeToHex(cComposed) + "  (" + len(cComposed) + " bytes)"
	? "Decomposed : " + cDecomposed + "  " + unicodeToHex(cDecomposed) + "  (" + len(cDecomposed) + " bytes)"
	? "Same bytes          : " + (cComposed = cDecomposed)
	? "Same after NFC      : " + (unicodeNFC(cComposed) = unicodeNFC(cDecomposed))
	? "unicodeEqual()      : " + unicodeEqual(cComposed, cDecomposed)
	? ""

	# The four normalization forms
	aTexts = ["Café", "ﬁle", "x²", "①②③", "Ｒｉｎｇ", "Å"]
	nCount = len(aTexts)
	for x = 1 to nCount
		cText = aTexts[x]
		? "Text: " + cText
		? "   NFC  : " + unicodePadRight(unicodeNFC(cText), 10) + unicodeToHex(unicodeNFC(cText))
		? "   NFD  : " + unicodePadRight(unicodeNFD(cText), 10) + unicodeToHex(unicodeNFD(cText))
		? "   NFKC : " + unicodePadRight(unicodeNFKC(cText), 10) + unicodeToHex(unicodeNFKC(cText))
		? "   NFKD : " + unicodePadRight(unicodeNFKD(cText), 10) + unicodeToHex(unicodeNFKD(cText))
	next
	? ""

	# Check the form of a string
	? "Is NFC (composed)   : " + unicodeIsNormalized(cComposed, UNICODE_NFC)
	? "Is NFC (decomposed) : " + unicodeIsNormalized(cDecomposed, UNICODE_NFC)
	? "Is NFD (decomposed) : " + unicodeIsNormalized(cDecomposed, UNICODE_NFD)
	? "NFKC_Casefold       : " + unicodeNormalize("Ｓtraße ﬁ", UNICODE_NFKC_CASEFOLD)
