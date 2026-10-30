# Arabic Tashkeel (diacritics): count, find and remove them

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	aTexts = [
		"بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
		"الْعِلْمُ نُورٌ",
		"كَتَبَ الطَّالِبُ الدَّرْسَ",
		"العلم نور"
	]

	nCount = len(aTexts)
	for x = 1 to nCount
		cText = aTexts[x]
		? "Text           : " + cText
		? "Has Tashkeel   : " + unicodeArabicHasTashkeel(cText)
		? "Bytes          : " + len(cText)
		? "Codepoints     : " + unicodeLength(cText)
		? "Characters     : " + unicodeGraphemeCount(cText) + "  (a letter and its marks are one character)"
		? "Display width  : " + unicodeWidth(cText) + "  (the marks use no columns)"
		? "Without marks  : " + unicodeArabicStripTashkeel(cText)
		? ""
	next

	# Each character (grapheme cluster) with its codepoints
	cWord = "الرَّحْمَٰنِ"
	? "The characters of: " + cWord
	aGraphemes = unicodeGraphemes(cWord)
	nCount = len(aGraphemes)
	for x = 1 to nCount
		? "   " + x + " : " + unicodePadRight(aGraphemes[x], 3) + unicodeToHex(aGraphemes[x])
	next
	? ""

	# unicodeArabicStripTashkeel() removes the Arabic marks only,
	# unicodeStripMarks() removes all the marks (also the Hamza of أ and the accents of other scripts)
	cMixed = "أَكَلَ الأَسَدُ - Café"
	? "Text                         : " + cMixed
	? "unicodeArabicStripTashkeel() : " + unicodeArabicStripTashkeel(cMixed)
	? "unicodeStripMarks()          : " + unicodeStripMarks(cMixed)
	? ""

	# The Tashkeel table (built from the Unicode data: the nonspacing marks of the Arabic blocks)
	aPairs = unicodeArabicTashkeelPairs()
	? "Number of Tashkeel marks : " + len(aPairs)
	cLine = "First marks : "
	for x = 1 to 12
		cLine += unicodeToHex(unicodeChar(aPairs[x][1])) + " "
	next
	? cLine
