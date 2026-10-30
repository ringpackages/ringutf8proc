# Fuzz test: random text (including invalid UTF-8) checked with rules that must always hold
# Reports the problems found; Problems: 0 is the expected result

load "utf8proclib.ring"

# Global, so the code in eval() can read it
cFuzzInput = ""

# Codepoints used to build the random text (letters, marks, CJK, emoji parts, spaces, controls, Arabic)
aPoolCodes = [0x20, 0x20, 0x20, 0x41, 0x61, 0x7A, 0x27, 0x2C, 0x2E, 0x0A, 0x0D, 0x09, 0x00,
	0xE9, 0x301, 0x308, 0x327, 0xDF, 0x130, 0x131, 0x3A3, 0x3C3, 0x416, 0x1C5,
	0x4E00, 0x65E5, 0x672C, 0x3002, 0x3001, 0x300C, 0x300D, 0x3000, 0xFF21, 0xFF41,
	0x628, 0x64E, 0x651, 0x660, 0x915, 0x94D, 0x937, 0xAC00, 0x1100, 0x1161, 0x11A8,
	0x1F600, 0x1F468, 0x200D, 0x1F469, 0x1F467, 0x1F1EA, 0x1F1EC, 0x1F1EF, 0x1F1F5,
	0x1F44D, 0x1F3FD, 0xFE0F, 0x2764, 0xAD, 0x200B, 0xFB01, 0x2460, 0x2019, 0x2014, 0xFFFD, 0x10FFFF, 0xE000,
	0x627, 0x623, 0x625, 0x622, 0x671, 0x629, 0x649, 0x624, 0x626, 0x640, 0x644, 0x645, 0x64B, 0x650, 0x652,
	0x653, 0x654, 0x670, 0x6D6, 0x60C, 0x61B, 0x61F, 0x663, 0x6F4, 0xFEFB, 0xFDF2, 0xFEE3, 0x200C, 0x200F, 0x966]

func main
	nRuns = 3000
	unicodeSetupConsole()
	nProblems = 0
	nInvalid = 0
	for nRun = 1 to nRuns
		cStr = randomText()
		lCorrupt = random(4) = 0
		if lCorrupt
			cStr = corrupt(cStr)
		ok
		if utf8proc_isvalid(cStr)
			nProblems += checkValid(cStr)
		else
			nInvalid++
			nProblems += checkInvalid(cStr)
		ok
	next
	? "Runs: " + nRuns + "  Invalid inputs: " + nInvalid + "  Problems: " + nProblems

func randomText
	nCount = random(40)
	aCodes = []
	nPool = len(aPoolCodes)
	for x = 1 to nCount
		aCodes + aPoolCodes[random(nPool - 1) + 1]
	next
	return utf8proc_fromcodepoints(aCodes)

func corrupt cStr
	nSize = len(cStr)
	nTimes = random(3) + 1
	for x = 1 to nTimes
		cByte = char(random(255))
		if nSize = 0
			cStr = cByte
		else
			nPos = random(nSize - 1) + 1
			cStr = left(cStr, nPos - 1) + cByte + substr(cStr, nPos + 1)
		ok
		nSize = len(cStr)
	next
	return cStr

func problem cWhat, cStr
	? "PROBLEM: " + cWhat + " : " + unicodeToHex(utf8proc_replaceinvalid(cStr))
	return 1

func checkValid cStr
	nProblems = 0
	aGraphemes = utf8proc_graphemes(cStr)
	if joinList(aGraphemes, "") != cStr  nProblems += problem("graphemes join", cStr) ok
	if len(aGraphemes) != utf8proc_graphemecount(cStr)  nProblems += problem("graphemecount", cStr) ok
	aCodes = utf8proc_codepoints(cStr)
	if utf8proc_fromcodepoints(aCodes) != cStr  nProblems += problem("codepoints round trip", cStr) ok
	if len(aCodes) != utf8proc_length(cStr)  nProblems += problem("length", cStr) ok
	nWidth = 0
	nCount = len(aGraphemes)
	for x = 1 to nCount
		nWidth += utf8proc_displaywidth(aGraphemes[x])
	next
	if nWidth != utf8proc_displaywidth(cStr)  nProblems += problem("displaywidth sum", cStr) ok
	if utf8proc_NFC(utf8proc_NFD(cStr)) != utf8proc_NFC(cStr)  nProblems += problem("NFC(NFD)", cStr) ok
	if utf8proc_replaceinvalid(cStr) != cStr  nProblems += problem("replaceinvalid changed valid text", cStr) ok
	if utf8proc_length(utf8proc_upperstring(cStr)) != len(aCodes)  nProblems += problem("upper length", cStr) ok
	if utf8proc_length(utf8proc_titlestring(cStr)) != len(aCodes)  nProblems += problem("title length", cStr) ok
	cTrimmed = utf8proc_trim(cStr)
	if utf8proc_trim(cTrimmed) != cTrimmed or (cTrimmed != "" and utf8proc_find(cStr, cTrimmed) = 0)
		nProblems += problem("trim", cStr)
	ok
	if utf8proc_replace(cStr, "a", "a") != cStr  nProblems += problem("replace with the same text", cStr) ok
	if nCount > 0
		cLast = aGraphemes[nCount]
		if utf8proc_find(cStr, cLast) = 0  nProblems += problem("find last grapheme", cStr) ok
		if utf8proc_replace(cStr, cLast, "") = cStr  nProblems += problem("replace last grapheme", cStr) ok
	ok
	cNormalized = unicodeArabicNormalize(cStr)
	if unicodeArabicNormalize(cNormalized) != cNormalized  nProblems += problem("Arabic normalize twice", cStr) ok
	if unicodeArabicHasTashkeel(unicodeArabicStripTashkeel(cStr))  nProblems += problem("Tashkeel after strip", cStr) ok
	cAscii = utf8proc_asciidigits(cStr)
	if hasOtherDigits(cAscii)  nProblems += problem("non ASCII digits after asciidigits", cStr) ok
	if utf8proc_asciidigits(unicodeArabicDigits(cStr)) != cAscii  nProblems += problem("Arabic digits round trip", cStr) ok
	if utf8proc_mapchars(cStr, []) != cStr  nProblems += problem("mapchars without pairs", cStr) ok
	if unicodeArabicCharCount(cStr) > len(aCodes)  nProblems += problem("Arabic char count", cStr) ok
	cShaped = utf8proc_arabicshape(cStr)
	if utf8proc_length(cShaped) > len(aCodes)  nProblems += problem("shaping added codepoints", cStr) ok
	# The characters between Lam and Alef (transparent for joining) move after the Lam-Alef ligature
	if withoutTransparent(utf8proc_NFKD(cShaped)) != withoutTransparent(utf8proc_NFKD(cStr))
		nProblems += problem("shaping changed the text", cStr)
	ok
	cVisual = utf8proc_bidivisual(cStr, UNICODE_DIRECTION_AUTO)
	# (the width can change: a mark without a letter joins another character after reordering)
	if len(cVisual) != len(cStr) or utf8proc_length(cVisual) != len(aCodes)
		nProblems += problem("visual order changed the size", cStr)
	ok
	cConsole = utf8proc_avoidligatures(cVisual)
	if len(cConsole) != len(cVisual) or utf8proc_NFKC(cConsole) != utf8proc_NFKC(cVisual)
		nProblems += problem("avoid ligatures changed the text", cStr)
	ok
	if utf8proc_countranges(cStr, [[0x0590, 0x08FF], [0xFB1D, 0xFDFF], [0xFE70, 0xFEFF], [0x200F, 0x200F], [0x202B, 0x202B], [0x202E, 0x202E], [0x2067, 0x2067]]) = 0 and
	   utf8proc_bidivisual(cStr, UNICODE_DIRECTION_LTR) != cStr
		nProblems += problem("visual order changed LTR text", cStr)
	ok
	aWords = utf8proc_words(cStr)
	nCount = len(aWords)
	for x = 1 to nCount
		if aWords[x] = "" or substr(cStr, aWords[x]) = 0  nProblems += problem("word not in text", cStr) exit ok
	next
	for nMax = 1 to 12
		cCut = utf8proc_truncatewidth(cStr, nMax)
		if left(cStr, len(cCut)) != cCut or utf8proc_displaywidth(cCut) > nMax
			nProblems += problem("truncatewidth " + nMax, cStr)
		ok
		aLines = utf8proc_wrap(cStr, nMax)
		nLines = len(aLines)
		for x = 1 to nLines
			if utf8proc_displaywidth(aLines[x]) > nMax and utf8proc_graphemecount(aLines[x]) > 1
				nProblems += problem("wrap width " + nMax, cStr)
				exit
			ok
		next
		if withoutBreaks(joinList(aLines, "")) != withoutBreaks(cStr)
			nProblems += problem("wrap lost text " + nMax, cStr)
		ok
	next
	return nProblems

func checkInvalid cStr
	nProblems = 0
	cFuzzInput = cStr
	cFixed = utf8proc_replaceinvalid(cStr)
	if ! utf8proc_isvalid(cFixed)  nProblems += problem("replaceinvalid result invalid", cStr) ok
	# eval() is used because a "call" instruction that runs different functions can call the wrong one
	aFunctions = ["utf8proc_NFC", "utf8proc_NFKC_Casefold", "utf8proc_graphemes", "utf8proc_codepoints",
		"utf8proc_length", "utf8proc_displaywidth", "utf8proc_upperstring", "utf8proc_words", "utf8proc_graphemecount",
		"utf8proc_trim", "utf8proc_titlestring", "utf8proc_asciidigits", "unicodeArabicNormalize", "unicodeArabicSearchKey",
		"utf8proc_arabicshape", "unicodeBidiVisual", "unicodeArabicVisual", "unicodeArabicConsole"]
	nCount = len(aFunctions)
	for x = 1 to nCount
		lRaised = False
		try
			eval("" + aFunctions[x] + "(cFuzzInput)")
		catch
			lRaised = True
		done
		if ! lRaised  nProblems += problem(aFunctions[x] + " accepted invalid input", cStr) ok
	next
	lRaised = False
	try utf8proc_wrap(cStr, 5) catch lRaised = True done
	if ! lRaised  nProblems += problem("wrap accepted invalid input", cStr) ok
	lRaised = False
	try utf8proc_find(cStr, "a") catch lRaised = True done
	if ! lRaised  nProblems += problem("find accepted invalid input", cStr) ok
	return nProblems

func withoutTransparent cStr
	# Remove the marks and the format characters (and the space that NFKC adds before some isolated marks)
	aCodes = utf8proc_codepoints(cStr)
	aKept = []
	nCount = len(aCodes)
	for x = 1 to nCount
		nCategory = utf8proc_category(aCodes[x])
		if ! ( nCategory = UTF8PROC_CATEGORY_MN or nCategory = UTF8PROC_CATEGORY_ME or nCategory = UTF8PROC_CATEGORY_CF )
			aKept + aCodes[x]
		ok
	next
	return utf8proc_fromcodepoints(aKept)

func hasOtherDigits cStr
	aCodes = utf8proc_codepoints(cStr)
	nCount = len(aCodes)
	for x = 1 to nCount
		if aCodes[x] > 0x7F and utf8proc_digitvalue(aCodes[x]) >= 0
			return True
		ok
	next
	return False

func withoutBreaks cStr
	# wrap() removes the spaces where lines break and the line break characters
	# (filtered by codepoints: Ring substr() replace is not safe for strings that contain char(0))
	aCodes = utf8proc_codepoints(cStr)
	aKept = []
	nCount = len(aCodes)
	for x = 1 to nCount
		if ! ( aCodes[x] = 0x0A or aCodes[x] = 0x0D or utf8proc_category(aCodes[x]) = UTF8PROC_CATEGORY_ZS )
			aKept + aCodes[x]
		ok
	next
	return utf8proc_fromcodepoints(aKept)

func joinList aList, cSep
	cResult = ""
	nCount = len(aList)
	for x = 1 to nCount
		if x > 1 cResult += cSep ok
		cResult += aList[x]
	next
	return cResult
