# Moving from UTF8Lib (ringutf8.ring) to UTF8ProcLib: the functions that do the same work

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	cText = "Ring رينج 😀"

	showRow("utf8Decode(text)", "unicodeCodepoints(cStr)", joinNumbers(unicodeCodepoints(cText)))
	showRow("utf8Encode(codepoints)", "unicodeFromCodepoints(aCodes)", unicodeFromCodepoints([0x52, 0x69, 0x6E, 0x67]))
	showRow("utf8Char(cp)", "unicodeChar(nCode)", unicodeChar(0x628))
	showRow("utf8Len(text)", "unicodeLength(cStr) / unicodeGraphemeCount(cStr)", "" + unicodeLength(cText) + " / " + unicodeGraphemeCount(cText))
	showRow("utf8Sub(text, start, count)", "unicodeSubStr(cStr, nStart, nCount)", unicodeSubStr(cText, 6, 4))
	showRow("utf8Reverse(text)", "unicodeReverse(cStr)", unicodeReverse("abc"))
	showRow("utf8Code(text, pos)", "unicodeCodepoints(cStr)[nPos]", "" + unicodeCodepoints(cText)[6])
	showRow("utf8Bytes(cp)", "len(unicodeChar(nCode))", "" + len(unicodeChar(0x1F600)))
	showRow("utf8Valid(text)", "unicodeIsValid(cStr)", "" + unicodeIsValid(cText))
	showRow("utf8IsArabic(cp)", "unicodeIsArabic(vChar)", "" + unicodeIsArabic(0x628))
	showRow("utf8IsArabicLetter(cp)", "unicodeIsArabic(vChar) and unicodeIsLetter(vChar)", "" + (unicodeIsArabic("ب") and unicodeIsLetter("ب")))
	showRow("utf8IsArabicDiacritic(cp)", "unicodeIsArabic(vChar) and unicodeIsMark(vChar)", "" + (unicodeIsArabic(0x64E) and unicodeIsMark(0x64E)))
	showRow("utf8IsLatin(cp)", "unicodeScript(vChar) = " + '"Latin"', "" + (unicodeScript("é") = "Latin"))
	showRow("utf8IsDigit(cp)", "unicodeIsDigit(vChar) (all the scripts)", "" + unicodeIsDigit("٣"))
	showRow("utf8IsArabicDigit(cp)", "unicodeIsDigit(vChar) and unicodeIsArabic(vChar)", "" + (unicodeIsDigit("٣") and unicodeIsArabic("٣")))
	showRow("utf8IsSpace(cp)", "unicodeIsSpace(vChar)", "" + unicodeIsSpace(0x3000))
	showRow("utf8IsCJK(cp)", "unicodeIsCJK(vChar)", "" + unicodeIsCJK("日"))
	showRow("utf8IsRTL(cp)", "unicodeIsRTL(vChar)", "" + unicodeIsRTL("ب"))
	showRow("arabicGetForm(cp, form)", "unicodeArabicForm(vChar, nForm)", unicodeToHex(unicodeChar(unicodeArabicForm("ب", UNICODE_FORM_INITIAL))))
	showRow("arabicGetJoinType(cp)", "unicodeArabicJoiningType(vChar)", "" + unicodeArabicJoiningType("ب"))
	showRow("arabicShape(text)", "unicodeArabicShape(cStr)", unicodeToHex(unicodeArabicShape("سلام")))
	showRow("arabicShapeOnly(text)", "unicodeArabicShape(cStr)", unicodeToHex(unicodeArabicShape("لا")))
	showRow("bidiReorder(text)", "unicodeBidiVisual(cStr)", unicodeToHex(unicodeBidiVisual("ab بت")))
	showRow("arabicReverse(text)", "unicodeReverse(cStr) (keeps the marks after the letters)", unicodeToHex(unicodeReverse("بَت")))
	showRow("arabicProcess(text)", "unicodeArabicConsole(cStr) (terminals)", unicodeToHex(unicodeArabicConsole("سلام")))
	showRow("arabicShapeForGame(text)", "unicodeArabicVisual(cStr)", unicodeToHex(unicodeArabicVisual("سلام")))
	showRow("utf8ToHex(text)", "unicodeToHexBytes(cStr)", unicodeToHexBytes("€"))
	showRow("utf8CodepointsToHex(codepoints)", "unicodeToHex(cStr)", unicodeToHex("€"))
	showRow("utf8PrintInfo(text)", "? unicodeInfo(cStr)", "")
	? unicodeInfo("بَ😀")

func showRow cOld, cNew, cResult
	? unicodePadRight(cOld, 34) + unicodePadRight(cNew, 60) + cResult

func joinNumbers aList
	cResult = ""
	nCount = len(aList)
	for x = 1 to nCount
		if x > 1
			cResult += " "
		ok
		cResult += aList[x]
	next
	return cResult
