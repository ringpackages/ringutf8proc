# Unicode properties of Arabic characters

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	aChars = [
		["ب", "Letter Beh"],
		["ة", "Letter Teh Marbuta"],
		["ء", "Letter Hamza"],
		[unicodeChar(0x64E), "Fatha (mark)"],
		[unicodeChar(0x651), "Shadda (mark)"],
		[unicodeChar(0x670), "Superscript Alef"],
		["ـ", "Tatweel"],
		["٣", "Arabic-Indic digit"],
		["۳", "Persian digit"],
		["،", "Arabic comma"],
		["؟", "Arabic question mark"],
		["ﻻ", "Lam-Alef ligature"],
		[unicodeChar(0x200C), "Zero width non-joiner"],
		[unicodeChar(0x200F), "Right-to-left mark"],
		["a", "Latin letter (for comparison)"]
	]

	? unicodePadRight("Code", 10) + unicodePadRight("Cat", 5) + unicodePadRight("Bidi", 6) +
	  unicodePadRight("RTL", 5) + unicodePadRight("Width", 7) + unicodePadRight("Arabic", 8) + "Name"
	? copy("-", 72)
	nCount = len(aChars)
	for x = 1 to nCount
		cChar = aChars[x][1]
		? unicodePadRight(unicodeToHex(cChar), 10) + unicodePadRight(unicodeCategory(cChar), 5) +
		  unicodePadRight(unicodeBidiClass(cChar), 6) + unicodePadRight("" + unicodeIsRTL(cChar), 5) +
		  unicodePadRight("" + unicodeCharWidth(cChar), 7) + unicodePadRight("" + unicodeIsArabic(cChar), 8) +
		  aChars[x][2]
	next
	? ""

	# Classification of the characters of a word
	cWord = "مُدَرِّسَةٌ٢"
	? "Word: " + cWord
	aCodes = unicodeCodepoints(cWord)
	nCount = len(aCodes)
	for x = 1 to nCount
		nCode = aCodes[x]
		if unicodeIsLetter(nCode) and ! unicodeIsMark(nCode)
			cKind = "letter"
		but unicodeIsMark(nCode)
			cKind = "mark"
		but unicodeIsDigit(nCode)
			cKind = "digit " + unicodeDigitValue(nCode)
		else
			cKind = "other"
		ok
		? "   " + unicodeToHex(unicodeChar(nCode)) + " : " + cKind
	next
	? ""

	# Arabic characters in mixed text
	aTexts = ["Ring رينج 1.28", "Hello", "مرحبا"]
	nCount = len(aTexts)
	for x = 1 to nCount
		? unicodePadRight(aTexts[x], 16) + " has Arabic: " + unicodeHasArabic(aTexts[x]) +
		  "  Arabic codepoints: " + unicodeArabicCharCount(aTexts[x])
	next
