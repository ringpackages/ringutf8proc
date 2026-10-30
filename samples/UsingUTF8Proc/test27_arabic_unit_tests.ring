# Unit tests for Arabic text

load "utf8proclib.ring"

nArabicTestsPassed = 0
nArabicTestsFailed = 0

func main
	unicodeSetupConsole()

	cFatha = unicodeChar(0x64E)
	cShadda = unicodeChar(0x651)
	cSukun = unicodeChar(0x652)
	cBasmala = "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
	cKnowledge = "الْعِلْمُ نُورٌ"

	? "Tashkeel"
	check("Strip Tashkeel", unicodeArabicStripTashkeel(cKnowledge) = "العلم نور")
	check("Strip Tashkeel (Basmala, Superscript Alef)", unicodeArabicStripTashkeel(cBasmala) = "بسم الله الرحمن الرحيم")
	check("Strip Tashkeel keeps Hamza and Madda", unicodeArabicStripTashkeel("أَسَدٌ آلَةٌ إِنَاءٌ") = "أسد آلة إناء")
	check("Strip Tashkeel keeps Latin accents", unicodeArabicStripTashkeel("كَتَبَ Café") = "كتب Café")
	check("Strip Tashkeel of decomposed Hamza", unicodeArabicStripTashkeel("ا" + unicodeChar(0x654) + cFatha) = "أ")
	check("Has Tashkeel", unicodeArabicHasTashkeel("كَتَبَ") and ! unicodeArabicHasTashkeel("كتب"))
	check("Hamza is not Tashkeel", ! unicodeArabicHasTashkeel("أسد"))
	check("Tashkeel table", len(unicodeArabicTashkeelPairs()) > 100 and unicodeArabicTashkeelPairs()[1][2] = -1)
	check("unicodeStripMarks removes Hamza above", unicodeStripMarks("أسد") = "اسد")

	? "Normalization"
	check("Remove Tatweel", unicodeArabicRemoveTatweel("كتـــاب") = "كتاب")
	check("Normalize Alef forms", unicodeArabicNormalizeAlef("أ إ آ ٱ") = "ا ا ا ا")
	check("Normalize presentation forms", unicodeArabicNormalize(unicodeFromCodepoints([0xFEE3, 0xFEAE, 0xFEA3, 0xFE92, 0xFE8E])) = "مرحبا")
	check("Normalize Lam-Alef ligature", unicodeArabicNormalize(unicodeChar(0xFEFB)) = "لا")
	check("Normalize Allah ligature", unicodeArabicNormalize(unicodeChar(0xFDF2)) = "الله")
	check("Normalize all steps", unicodeArabicNormalize("إِنَّ الْعِلْمَ نُــــورٌ") = "ان العلم نور")
	check("Normalize composes after removing a mark", unicodeArabicNormalize("A" + unicodeChar(0x654) + unicodeChar(0x301)) = unicodeChar(0xC1))
	check("Strip Tashkeel composes after removing a mark", unicodeArabicStripTashkeel(unicodeChar(0x1100) + unicodeChar(0x653) + unicodeChar(0x1161)) = unicodeChar(0xAC00))
	check("NFC composes Alef + Hamza above", unicodeNFC("ا" + unicodeChar(0x654)) = "أ")
	check("NFD decomposes Alef with Madda", unicodeToHex(unicodeNFD("آ")) = "U+0627 U+0653")
	check("NFKC of Arabic-Indic digits keeps them", unicodeNFKC("٣") = "٣")

	? "Search and sorting"
	check("Search key: Teh Marbuta", unicodeArabicSearchKey("مدرسة") = unicodeArabicSearchKey("مدرسه"))
	check("Search key: Alef Maksura", unicodeArabicSearchKey("مستشفى") = unicodeArabicSearchKey("مستشفي"))
	check("Search key: Waw with Hamza", unicodeArabicSearchKey("سؤال") = "سوال")
	check("Search key: Yeh with Hamza", unicodeArabicSearchKey("شاطئ") = "شاطي")
	check("Search key: digits", unicodeArabicSearchKey("الجزء ٢") = unicodeArabicSearchKey("الجزء 2"))
	check("Search key: Tashkeel and Tatweel", unicodeArabicSearchKey("مَـــدْرَسَةٌ") = "مدرسه")
	check("Search", unicodeArabicSearch("ذَهَبْتُ إِلَى المَدْرَسَةِ", "المدرسه") and ! unicodeArabicSearch("كتاب", "قلم"))
	check("Compare equal", unicodeArabicCompare("مَدْرَسَة", "مدرسه") = 0)
	check("Compare order", unicodeArabicCompare("باب", "بيت") = -1 and unicodeArabicCompare("ياء", "ألف") = 1)
	check("Sort", listEqual(unicodeArabicSort(["يوم", "إبرة", "باب", "أرض", "تفاح"]), ["إبرة", "أرض", "باب", "تفاح", "يوم"]))
	check("Sort presentation form", listEqual(unicodeArabicSort(["ماء", unicodeChar(0xFEFB) + "عب", "كتاب"]), ["كتاب", unicodeChar(0xFEFB) + "عب", "ماء"]))

	? "Digits"
	check("Arabic-Indic digits", unicodeArabicDigits("2026") = "٢٠٢٦")
	check("Persian digits", unicodePersianDigits("2026") = "۲۰۲۶")
	check("ASCII digits", unicodeAsciiDigits("٢٠٢٦ ۱۴۰۵") = "2026 1405")
	check("ASCII digits of other scripts", unicodeAsciiDigits("४२ ๙ ７") = "42 9 7")
	check("Persian to Arabic-Indic", unicodeArabicDigits("۱۲۳") = "١٢٣")
	check("Digit value", unicodeDigitValue("٧") = 7 and unicodeDigitValue("۸") = 8 and unicodeDigitValue("ب") = -1)
	check("Digit value of math digits", unicodeDigitValue(0x1D7D8) = 0 and unicodeDigitValue(0x1D7E1) = 9)
	check("Calculation", number(unicodeAsciiDigits("١٢٥")) * 4 = 500)

	? "Characters and properties"
	check("Is Arabic", unicodeIsArabic("ب") and unicodeIsArabic(0xFEFB) and ! unicodeIsArabic("a"))
	check("Has Arabic", unicodeHasArabic("Ring رينج") and ! unicodeHasArabic("Ring"))
	check("Arabic char count", unicodeArabicCharCount("كتاب book ١") = 5)
	check("Bidi class AL", unicodeBidiClass("ب") = "AL")
	check("Bidi class AN", unicodeBidiClass("٣") = "AN")
	check("Bidi class NSM", unicodeBidiClass(cFatha) = "NSM")
	check("Is RTL", unicodeIsRTL("ب") and unicodeIsRTL(0x200F) and ! unicodeIsRTL("a") and ! unicodeIsRTL("٣"))
	check("Category of letters and marks", unicodeCategory("ب") = "Lo" and unicodeCategory(cShadda) = "Mn")
	check("Category of Tatweel", unicodeCategory("ـ") = "Lm")
	check("Arabic letter is a letter", unicodeIsLetter("ب") and ! unicodeIsMark("ب"))
	check("Arabic mark is a mark", unicodeIsMark(cSukun) and ! unicodeIsLetter(cSukun))
	check("Arabic digit is a digit", unicodeIsDigit("٣") and unicodeIsNumber("٣"))
	check("Arabic punctuation", unicodeIsPunct("،") and unicodeIsPunct("؟") and unicodeIsPunct("؛"))
	check("No letter case", unicodeUpper("كتاب") = "كتاب" and unicodeLower("كتاب") = "كتاب" and ! unicodeIsUpper("ب"))

	? "Graphemes, width and words"
	check("Grapheme with two marks", unicodeGraphemeCount("رَّ") = 1 and unicodeLength("رَّ") = 3)
	check("Graphemes of a word", listEqual(unicodeGraphemes("كَتَبَ"), ["كَ", "تَ", "بَ"]))
	check("Graphemes of Basmala", unicodeGraphemeCount(cBasmala) = 22 and unicodeLength(cBasmala) = 38)
	check("Width ignores marks", unicodeWidth(cKnowledge) = 9 and unicodeWidth("العلم نور") = 9)
	check("Reverse keeps the marks", unicodeReverse("كَتَبَ") = "بَتَكَ")
	check("SubString by characters", unicodeSubStr("كَتَبَ", 2, 1) = "تَ")
	check("Words with Arabic punctuation", listEqual(unicodeWords("العلم نورٌ، والجهل ظلام؛ هل تقرأ؟"), ["العلم", "نورٌ", "والجهل", "ظلام", "هل", "تقرأ"]))
	check("Word count", unicodeWordCount(cBasmala) = 4)
	check("Wrap Arabic text", listEqual(unicodeWrap("العلم نور والجهل ظلام", 10), ["العلم نور", "والجهل", "ظلام"]))
	check("Wrap ignores marks width", len(unicodeWrap(cKnowledge, 9)) = 1)
	check("Truncate keeps marks", unicodeTruncate("كَتَبَ", 2) = "كَتَ")
	check("Pad by width", unicodePadRight(cKnowledge, 11) = cKnowledge + "  ")

	? "Trim, find and replace"
	check("Trim Arabic text", unicodeTrim(unicodeChar(0x3000) + " نص عربي " + nl) = "نص عربي")
	check("Find a word", unicodeFind("العلم نور والجهل ظلام", "نور") = 7)
	check("Find doesn't split a letter and its marks", unicodeFind("كَتَبَ", "ك") = 0 and unicodeFind("كَتَبَ", "كَ") = 1)
	check("Replace a word", unicodeReplace("العلم نور", "نور", "ضياء") = "العلم ضياء")
	check("Replace doesn't split a letter and its marks", unicodeReplace("كَتَبَ", "ت", "د") = "كَتَبَ")
	check("Map characters", unicodeMapChars("كتاب", [[0x643, "ك"], [0x627, -1]]) = "كتب")
	check("Count in ranges", unicodeCountInRanges("abc كتاب", [[0x600, 0x6FF]]) = 4)
	check("Remove ignorable (RLM)", unicodeRemoveIgnorable(unicodeChar(0x200F) + "نص") = "نص")
	check("Slug of Arabic text", unicodeSlug("الْعِلْمُ نُورٌ!") = "العلم-نور")

	? "UnicodeString class"
	oText = new UnicodeString("الصَّفْحَةُ ١٢")
	check("hasArabic", oText.hasArabic())
	check("toAsciiDigits", oText.toAsciiDigits().value() = "الصَّفْحَةُ 12")
	check("arabicStripTashkeel", oText.arabicStripTashkeel().value() = "الصفحة 12")
	check("toArabicDigits", oText.toArabicDigits().value() = "الصفحة ١٢")
	oShaped = new UnicodeString(unicodeChar(0xFEFB) + "عـــب")
	check("arabicNormalize", oShaped.arabicNormalize().value() = "لاعب")

	? "Errors"
	check("Map pair without a target", raisesError('unicodeMapChars("a", [[97]])'))
	check("Map pair with a surrogate", raisesError('unicodeMapChars("a", [[0xD800, 97]])'))
	check("Map pair with a bad target", raisesError('unicodeMapChars("a", [[97, 0x110000]])'))
	check("Count ranges with a bad range", raisesError('unicodeCountInRanges("a", [[1]])'))
	check("Digit value out of range", raisesError("unicodeDigitValue(-1)"))
	check("Invalid UTF-8", raisesError('unicodeArabicNormalize("ب" + char(0xFF))'))

	? ""
	? "Passed: " + nArabicTestsPassed + "  Failed: " + nArabicTestsFailed

func check cName, lResult
	if lResult
		nArabicTestsPassed++
		? "  [PASS] " + cName
	else
		nArabicTestsFailed++
		? "  [FAIL] " + cName
	ok

func listEqual aList1, aList2
	nSize = len(aList1)
	if nSize != len(aList2)
		return False
	ok
	for nItem = 1 to nSize
		if aList1[nItem] != aList2[nItem]
			return False
		ok
	next
	return True

func raisesError cCode
	# eval() is used because a "call" instruction that runs different functions can call the wrong one
	try
		eval(cCode)
	catch
		return True
	done
	return False
