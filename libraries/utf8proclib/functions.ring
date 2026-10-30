# Library Information

func unicodeVersion
	return utf8proc_unicode_version()

func unicodeLibVersion
	return utf8proc_version()

func unicodeSetupConsole
	# The Windows console shows UTF-8 output correctly after switching to code page 65001
	if isWindows()
		system("chcp 65001 > nul")
	ok

func unicodeSetupVisualConsole
	# Before printing text in visual order (from unicodeArabicVisual() or unicodeBidiVisual()):
	# Windows: use UTF-8 (Windows Terminal doesn't reorder right-to-left text, so visual order is needed)
	# Other systems: ESC[8l asks terminals that reorder right-to-left text (like VTE) to keep the visual order
	if isWindows()
		system("chcp 65001 > nul")
	else
		see char(27) + "[8l"
	ok

# Validation

func unicodeIsValid cStr
	return utf8proc_isvalid(cStr)

func unicodeFixInvalid cStr
	return utf8proc_replaceinvalid(cStr)

# Normalization

func unicodeNFC cStr
	return utf8proc_NFC(cStr)

func unicodeNFD cStr
	return utf8proc_NFD(cStr)

func unicodeNFKC cStr
	return utf8proc_NFKC(cStr)

func unicodeNFKD cStr
	return utf8proc_NFKD(cStr)

func unicodeNFKCCaseFold cStr
	return utf8proc_NFKC_Casefold(cStr)

func unicodeNormalize cStr, cForm
	switch upper(cForm)
		on UNICODE_NFC
			return utf8proc_NFC(cStr)
		on UNICODE_NFD
			return utf8proc_NFD(cStr)
		on UNICODE_NFKC
			return utf8proc_NFKC(cStr)
		on UNICODE_NFKD
			return utf8proc_NFKD(cStr)
		on UNICODE_NFKC_CASEFOLD
			return utf8proc_NFKC_Casefold(cStr)
	off
	raise(UNICODE_ERRORPREFIX + "Unknown normalization form: " + cForm)

func unicodeIsNormalized cStr, cForm
	return unicodeNormalize(cStr, cForm) = cStr

# Case Mapping and Comparison

func unicodeUpper cStr
	return utf8proc_upperstring(cStr)

func unicodeLower cStr
	return utf8proc_lowerstring(cStr)

func unicodeTitle cStr
	return utf8proc_titlestring(cStr)

func unicodeCaseFold cStr
	return utf8proc_map(cStr, UTF8PROC_STABLE | UTF8PROC_COMPOSE | UTF8PROC_CASEFOLD)

func unicodeEqual cStr1, cStr2
	return utf8proc_NFC(cStr1) = utf8proc_NFC(cStr2)

func unicodeEqualIgnoreCase cStr1, cStr2
	return utf8proc_NFKC_Casefold(cStr1) = utf8proc_NFKC_Casefold(cStr2)

# Text Cleanup

func unicodeStripMarks cStr
	return utf8proc_map(cStr, UTF8PROC_STABLE | UTF8PROC_COMPOSE | UTF8PROC_STRIPMARK)

func unicodeStripControls cStr
	return utf8proc_map(cStr, UTF8PROC_STABLE | UTF8PROC_COMPOSE | UTF8PROC_STRIPCC)

func unicodeRemoveIgnorable cStr
	return utf8proc_map(cStr, UTF8PROC_STABLE | UTF8PROC_COMPOSE | UTF8PROC_IGNORE)

func unicodeLump cStr
	return utf8proc_map(cStr, UTF8PROC_STABLE | UTF8PROC_COMPOSE | UTF8PROC_LUMP)

func unicodeSlug cStr
	cSimple = utf8proc_map(cStr, UTF8PROC_STABLE | UTF8PROC_COMPOSE | UTF8PROC_COMPAT |
			UTF8PROC_CASEFOLD | UTF8PROC_STRIPMARK | UTF8PROC_LUMP | UTF8PROC_IGNORE)
	# Apostrophes are removed, so "Don't" becomes "dont"
	aWords = utf8proc_words(substr(cSimple, "'", ""))
	cSlug = ""
	nCount = len(aWords)
	for x = 1 to nCount
		if x > 1
			cSlug += UNICODE_SLUGSEPARATOR
		ok
		cSlug += aWords[x]
	next
	return cSlug

# Trim, Find and Replace (by grapheme clusters, safe for strings that contain char(0))

func unicodeTrim cStr
	return utf8proc_trim(cStr)

func unicodeTrimLeft cStr
	return utf8proc_trimleft(cStr)

func unicodeTrimRight cStr
	return utf8proc_trimright(cStr)

func unicodeFind cStr, cSubStr
	return utf8proc_find(cStr, cSubStr)

func unicodeReplace cStr, cOld, cNew
	return utf8proc_replace(cStr, cOld, cNew)

# Words and Lines

func unicodeWords cStr
	return utf8proc_words(cStr)

func unicodeWordCount cStr
	return len(utf8proc_words(cStr))

func unicodeWrap cStr, nWidth
	return utf8proc_wrap(cStr, nWidth)

func unicodeWrapText cStr, nWidth
	aLines = utf8proc_wrap(cStr, nWidth)
	cResult = ""
	nCount = len(aLines)
	for x = 1 to nCount
		if x > 1
			cResult += nl
		ok
		cResult += aLines[x]
	next
	return cResult

# Search and Sorting (ignoring case, accents and width differences)

func unicodeSearchKey cStr
	return utf8proc_map(cStr, UTF8PROC_STABLE | UTF8PROC_COMPOSE | UTF8PROC_COMPAT |
			UTF8PROC_CASEFOLD | UTF8PROC_STRIPMARK | UTF8PROC_IGNORE)

func unicodeSearch cStr, cQuery
	return substr(unicodeSearchKey(cStr), unicodeSearchKey(cQuery)) > 0

func unicodeCompare cStr1, cStr2
	return unicodeCompareKeys(unicodeSearchKey(cStr1), unicodeSearchKey(cStr2))

func unicodeCompareKeys cKey1, cKey2
	nResult = strcmp(cKey1, cKey2)
	if nResult < 0
		return -1
	but nResult > 0
		return 1
	ok
	return 0

func unicodeSort aList
	aKeys = []
	nCount = len(aList)
	for x = 1 to nCount
		aKeys + unicodeSearchKey(aList[x])
	next
	return unicodeSortByKeys(aList, aKeys)

func unicodeSortByKeys aList, aKeys
	aPairs = []
	nCount = len(aList)
	for x = 1 to nCount
		aPairs + [aKeys[x], aList[x]]
	next
	aPairs = sort(aPairs, 1)
	aSorted = []
	for x = 1 to nCount
		aSorted + aPairs[x][2]
	next
	return aSorted

# Length and Display Width

func unicodeLength cStr
	return utf8proc_length(cStr)

func unicodeGraphemeCount cStr
	return utf8proc_graphemecount(cStr)

func unicodeWidth cStr
	return utf8proc_displaywidth(cStr)

func unicodeGraphemeWidth cGrapheme
	return utf8proc_displaywidth(cGrapheme)

func unicodeTruncate cStr, nWidth
	return utf8proc_truncatewidth(cStr, nWidth)

func unicodePadRight cStr, nWidth
	nSpaces = nWidth - unicodeWidth(cStr)
	if nSpaces <= 0
		return cStr
	ok
	return cStr + copy(" ", nSpaces)

func unicodePadLeft cStr, nWidth
	nSpaces = nWidth - unicodeWidth(cStr)
	if nSpaces <= 0
		return cStr
	ok
	return copy(" ", nSpaces) + cStr

func unicodeCenter cStr, nWidth
	nSpaces = nWidth - unicodeWidth(cStr)
	if nSpaces <= 0
		return cStr
	ok
	nLeft = floor(nSpaces / 2)
	return copy(" ", nLeft) + cStr + copy(" ", nSpaces - nLeft)

# Grapheme Clusters (user-perceived characters)

func unicodeGraphemes cStr
	return utf8proc_graphemes(cStr)

func unicodeSubStr cStr, nStart, nCount
	aGraphemes = utf8proc_graphemes(cStr)
	nTotal = len(aGraphemes)
	if nStart < 1
		nStart = 1
	ok
	nEnd = nStart + nCount - 1
	if nEnd > nTotal
		nEnd = nTotal
	ok
	cResult = ""
	for x = nStart to nEnd
		cResult += aGraphemes[x]
	next
	return cResult

func unicodeLeft cStr, nCount
	return unicodeSubStr(cStr, 1, nCount)

func unicodeRight cStr, nCount
	nTotal = utf8proc_graphemecount(cStr)
	if nCount > nTotal
		nCount = nTotal
	ok
	return unicodeSubStr(cStr, nTotal - nCount + 1, nCount)

func unicodeReverse cStr
	aGraphemes = utf8proc_graphemes(cStr)
	cResult = ""
	for x = len(aGraphemes) to 1 step -1
		cResult += aGraphemes[x]
	next
	return cResult

# Character Mapping

func unicodeMapChars cStr, aPairs
	# aPairs: [nFrom, vTo] where vTo is a codepoint, -1 (remove) or a string
	return utf8proc_mapchars(cStr, aPairs)

func unicodeCountInRanges cStr, aRanges
	return utf8proc_countranges(cStr, aRanges)

# Digits (decimal digits of all the scripts)

func unicodeDigitValue vChar
	return utf8proc_digitvalue(unicodeCodeOf(vChar))

func unicodeAsciiDigits cStr
	return utf8proc_asciidigits(cStr)

func unicodeArabicDigits cStr
	return unicodeDigitsFrom(cStr, UNICODE_ARABICZERO)

func unicodePersianDigits cStr
	return unicodeDigitsFrom(cStr, UNICODE_PERSIANZERO)

func unicodeDigitsFrom cStr, nZero
	# Convert the digits of any script to the digits that start from the codepoint nZero
	aPairs = []
	for nDigit = 0 to 9
		aPairs + [ascii("0") + nDigit, nZero + nDigit]
	next
	return utf8proc_mapchars(utf8proc_asciidigits(cStr), aPairs)

# Arabic Text

func unicodeIsArabic vChar
	nCode = unicodeCodeOf(vChar)
	nCount = len(UNICODE_ARABICRANGES)
	for x = 1 to nCount
		if nCode >= UNICODE_ARABICRANGES[x][1] and nCode <= UNICODE_ARABICRANGES[x][2]
			return True
		ok
	next
	return False

func unicodeHasArabic cStr
	return utf8proc_countranges(cStr, UNICODE_ARABICRANGES) > 0

func unicodeArabicCharCount cStr
	return utf8proc_countranges(cStr, UNICODE_ARABICRANGES)

func unicodeArabicTashkeelPairs
	# The Tashkeel (diacritics, including the Quranic marks) are the nonspacing marks of the Arabic blocks
	if len(aUnicodeArabicTashkeelPairs) = 0
		nCount = len(UNICODE_ARABICRANGES)
		for x = 1 to nCount
			for nCode = UNICODE_ARABICRANGES[x][1] to UNICODE_ARABICRANGES[x][2]
				if utf8proc_category(nCode) = UTF8PROC_CATEGORY_MN
					aUnicodeArabicTashkeelPairs + [nCode, -1]
				ok
			next
		next
	ok
	return aUnicodeArabicTashkeelPairs

func unicodeArabicNormalizePairs
	if len(aUnicodeArabicNormalizePairs) = 0
		aTashkeel = unicodeArabicTashkeelPairs()
		nCount = len(aTashkeel)
		for x = 1 to nCount
			aUnicodeArabicNormalizePairs + aTashkeel[x]
		next
		aUnicodeArabicNormalizePairs + [UNICODE_ARABICTATWEEL, -1]
		nCount = len(UNICODE_ARABICALEFPAIRS)
		for x = 1 to nCount
			aUnicodeArabicNormalizePairs + UNICODE_ARABICALEFPAIRS[x]
		next
	ok
	return aUnicodeArabicNormalizePairs

func unicodeArabicStripTashkeel cStr
	# NFC keeps the Hamza and the Madda in the letters (like U+0623 and U+0622)
	# NFC again after removing the marks: a removed mark could separate characters that compose
	return utf8proc_NFC(utf8proc_mapchars(utf8proc_NFC(cStr), unicodeArabicTashkeelPairs()))

func unicodeArabicHasTashkeel cStr
	cComposed = utf8proc_NFC(cStr)
	return utf8proc_mapchars(cComposed, unicodeArabicTashkeelPairs()) != cComposed

func unicodeArabicRemoveTatweel cStr
	return utf8proc_mapchars(cStr, [[UNICODE_ARABICTATWEEL, -1]])

func unicodeArabicNormalizeAlef cStr
	return utf8proc_mapchars(utf8proc_NFC(cStr), UNICODE_ARABICALEFPAIRS)

func unicodeArabicNormalize cStr
	# NFKC (presentation forms and ligatures become letters), then remove Tashkeel and Tatweel, then unify the Alef forms
	# NFC at the end: a removed mark could separate characters that compose
	return utf8proc_NFC(utf8proc_mapchars(utf8proc_NFKC(cStr), unicodeArabicNormalizePairs()))

func unicodeArabicSearchKey cStr
	cKey = utf8proc_mapchars(unicodeArabicNormalize(cStr), UNICODE_ARABICSEARCHPAIRS)
	return unicodeSearchKey(utf8proc_asciidigits(cKey))

func unicodeArabicSearch cStr, cQuery
	return substr(unicodeArabicSearchKey(cStr), unicodeArabicSearchKey(cQuery)) > 0

func unicodeArabicCompare cStr1, cStr2
	return unicodeCompareKeys(unicodeArabicSearchKey(cStr1), unicodeArabicSearchKey(cStr2))

func unicodeArabicSort aList
	aKeys = []
	nCount = len(aList)
	for x = 1 to nCount
		aKeys + unicodeArabicSearchKey(aList[x])
	next
	return unicodeSortByKeys(aList, aKeys)

# Arabic Shaping and Visual Order
# For renderers that don't shape Arabic or reorder right-to-left text:
# Windows Terminal, game engines (RayLib, SDL, Allegro) and simple PDF writers

func unicodeArabicShape cStr
	# The letters become presentation forms (isolated, initial, medial, final) and Lam-Alef ligatures
	return utf8proc_arabicshape(cStr)

func unicodeArabicJoiningType vChar
	return utf8proc_arabicjoiningtype(unicodeCodeOf(vChar))

func unicodeArabicForm vChar, nForm
	# Returns the presentation form, or 0 when the letter doesn't have this form
	return utf8proc_arabicform(unicodeCodeOf(vChar), nForm)

func unicodeBidiVisual cStr
	# The paragraph direction comes from the first strong character of each line
	return utf8proc_bidivisual(cStr, UNICODE_DIRECTION_AUTO)

func unicodeBidiVisualDirection cStr, nDirection
	return utf8proc_bidivisual(cStr, nDirection)

func unicodeArabicVisual cStr
	# Shape, then reorder: ready to print in Windows Terminal or to draw using a game engine
	return utf8proc_bidivisual(utf8proc_arabicshape(cStr), UNICODE_DIRECTION_AUTO)

func unicodeArabicVisualWrap cStr, nWidth
	# Wrap in logical order, then shape and reorder each line (lines are drawn from top to bottom)
	aLines = utf8proc_wrap(cStr, nWidth)
	nCount = len(aLines)
	for x = 1 to nCount
		aLines[x] = unicodeArabicVisual(aLines[x])
	next
	return aLines

func unicodeArabicConsole cStr
	# For terminals that join the letters but don't reorder right-to-left text (like Windows Terminal):
	# visual order, without the false Lam-Alef ligatures these terminals make from Alef + Lam (like in "al")
	return utf8proc_avoidligatures(unicodeArabicVisual(cStr))

func unicodeArabicConsoleWrap cStr, nWidth
	aLines = unicodeArabicVisualWrap(cStr, nWidth)
	nCount = len(aLines)
	for x = 1 to nCount
		aLines[x] = utf8proc_avoidligatures(aLines[x])
	next
	return aLines

# Codepoints

func unicodeCodepoints cStr
	return utf8proc_codepoints(cStr)

func unicodeFromCodepoints aCodes
	return utf8proc_fromcodepoints(aCodes)

func unicodeChar nCode
	return utf8proc_encode_char(nCode)

func unicodeCode cChar
	aResult = utf8proc_iterate(cChar, 1)
	if aResult[2] <= 0
		raise(UNICODE_ERRORPREFIX + "Expected a valid UTF-8 character")
	ok
	return aResult[1]

func unicodeToHex cStr
	aCodes = utf8proc_codepoints(cStr)
	cResult = ""
	nCount = len(aCodes)
	for x = 1 to nCount
		if x > 1
			cResult += " "
		ok
		cHex = upper(hex(aCodes[x]))
		if len(cHex) < 4
			cHex = copy("0", 4 - len(cHex)) + cHex
		ok
		cResult += "U+" + cHex
	next
	return cResult

func unicodeToHexBytes cStr
	# The UTF-8 bytes in hexadecimal ("E2 82 AC" for the Euro sign)
	cResult = ""
	nCount = len(cStr)
	for x = 1 to nCount
		if x > 1
			cResult += " "
		ok
		cHex = upper(hex(ascii(cStr[x])))
		if len(cHex) < 2
			cHex = "0" + cHex
		ok
		cResult += cHex
	next
	return cResult

func unicodeInfo cStr
	# A description of the string: sizes, then one line for each user-perceived character
	cInfo = "Bytes: " + len(cStr) + "  Valid UTF-8: " + utf8proc_isvalid(cStr)
	if ! utf8proc_isvalid(cStr)
		return cInfo + nl + "Hex bytes: " + unicodeToHexBytes(cStr)
	ok
	cInfo += "  Codepoints: " + utf8proc_length(cStr) + "  Characters: " + utf8proc_graphemecount(cStr) +
		 "  Width: " + utf8proc_displaywidth(cStr)
	aGraphemes = utf8proc_graphemes(cStr)
	nCount = len(aGraphemes)
	for x = 1 to nCount
		cGrapheme = aGraphemes[x]
		nCode = unicodeCode(cGrapheme)
		cInfo += nl + "  " + x + ": " + unicodeToHex(cGrapheme) + "  " + utf8proc_category_string(nCode) + "  " +
			 unicodeCategoryName(nCode) + "  " + unicodeScript(nCode) + "  width " + utf8proc_displaywidth(cGrapheme) +
			 "  bytes " + unicodeToHexBytes(cGrapheme)
	next
	return cInfo

# Character Properties (vChar is a codepoint number or a one character string)

func unicodeScript vChar
	# The script by Unicode blocks (an approximation of the Unicode Script property)
	nCode = unicodeCodeOf(vChar)
	nCategory = utf8proc_category(nCode)
	lLetter = nCategory >= UTF8PROC_CATEGORY_LU and nCategory <= UTF8PROC_CATEGORY_ME
	lDigit = nCode > 0x7F and nCategory >= UTF8PROC_CATEGORY_ND and nCategory <= UTF8PROC_CATEGORY_NO
	if ! ( lLetter or lDigit )
		return UNICODE_SCRIPTCOMMON
	ok
	nCount = len(UNICODE_SCRIPTRANGES)
	for x = 1 to nCount
		if nCode >= UNICODE_SCRIPTRANGES[x][1] and nCode <= UNICODE_SCRIPTRANGES[x][2]
			return UNICODE_SCRIPTRANGES[x][3]
		ok
	next
	if lDigit
		return UNICODE_SCRIPTCOMMON
	ok
	return UNICODE_SCRIPTOTHER

func unicodeIsCJK vChar
	# CJK ideographs (Han): the unified ideographs, their extensions and the compatibility ideographs
	return unicodeScript(vChar) = "Han"

func unicodeIsWide vChar
	return utf8proc_charwidth(unicodeCodeOf(vChar)) = 2


func unicodeCharInfo vChar
	return utf8proc_get_property(unicodeCodeOf(vChar))

func unicodeCategory vChar
	return utf8proc_category_string(unicodeCodeOf(vChar))

func unicodeCategoryName vChar
	return UNICODE_CATEGORYNAMES[utf8proc_category(unicodeCodeOf(vChar)) + 1]

func unicodeBidiClass vChar
	# The bidirectional class name: "L" (left to right), "R", "AL" (Arabic letter), "AN" (Arabic number), "NSM" (mark), ...
	nClass = utf8proc_get_property(unicodeCodeOf(vChar))[:bidiclass]
	if nClass < 1 or nClass > len(UNICODE_BIDICLASSNAMES)
		return ""
	ok
	return UNICODE_BIDICLASSNAMES[nClass]

func unicodeIsRTL vChar
	nClass = utf8proc_get_property(unicodeCodeOf(vChar))[:bidiclass]
	return nClass = UTF8PROC_BIDI_CLASS_R or nClass = UTF8PROC_BIDI_CLASS_AL

func unicodeCharWidth vChar
	return utf8proc_charwidth(unicodeCodeOf(vChar))

func unicodeIsLetter vChar
	return unicodeInCategory(vChar, UTF8PROC_CATEGORY_LU, UTF8PROC_CATEGORY_LO)

func unicodeIsMark vChar
	return unicodeInCategory(vChar, UTF8PROC_CATEGORY_MN, UTF8PROC_CATEGORY_ME)

func unicodeIsDigit vChar
	return unicodeInCategory(vChar, UTF8PROC_CATEGORY_ND, UTF8PROC_CATEGORY_ND)

func unicodeIsNumber vChar
	return unicodeInCategory(vChar, UTF8PROC_CATEGORY_ND, UTF8PROC_CATEGORY_NO)

func unicodeIsPunct vChar
	return unicodeInCategory(vChar, UTF8PROC_CATEGORY_PC, UTF8PROC_CATEGORY_PO)

func unicodeIsSymbol vChar
	return unicodeInCategory(vChar, UTF8PROC_CATEGORY_SM, UTF8PROC_CATEGORY_SO)

func unicodeIsSpace vChar
	nCode = unicodeCodeOf(vChar)
	# Tab, line feed, vertical tab, form feed, carriage return and next line
	if (nCode >= 9 and nCode <= 13) or nCode = 0x85
		return True
	ok
	return unicodeInCategory(nCode, UTF8PROC_CATEGORY_ZS, UTF8PROC_CATEGORY_ZP)

func unicodeIsControl vChar
	return unicodeInCategory(vChar, UTF8PROC_CATEGORY_CC, UTF8PROC_CATEGORY_CC)

func unicodeIsUpper vChar
	return utf8proc_isupper(unicodeCodeOf(vChar)) = 1

func unicodeIsLower vChar
	return utf8proc_islower(unicodeCodeOf(vChar)) = 1

func unicodeInCategory vChar, nFirstCategory, nLastCategory
	nCategory = utf8proc_category(unicodeCodeOf(vChar))
	return nCategory >= nFirstCategory and nCategory <= nLastCategory

func unicodeCodeOf vChar
	if isString(vChar)
		return unicodeCode(vChar)
	ok
	return vChar
