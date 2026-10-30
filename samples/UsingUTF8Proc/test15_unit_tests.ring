# Unit tests for the extension and the library

load "utf8proclib.ring"

nTestsPassed = 0
nTestsFailed = 0

func main
	unicodeSetupConsole()

	cE = unicodeChar(0xE9)
	cCombined = "e" + unicodeChar(0x301)
	cFamily = "👨‍👩‍👧"
	cInvalid = "a" + char(0xFF)

	? "Extension functions"
	check("utf8proc_version", utf8proc_version() = "2.12.0")
	check("utf8proc_unicode_version", len(utf8proc_unicode_version()) > 0)
	check("utf8proc_NFC", utf8proc_NFC(cCombined) = cE)
	check("utf8proc_NFD", utf8proc_NFD(cE) = cCombined)
	check("utf8proc_NFKC", utf8proc_NFKC("ﬁ²") = "fi2")
	check("utf8proc_NFKD", utf8proc_NFKD("①") = "1")
	check("utf8proc_NFKC_Casefold", utf8proc_NFKC_Casefold("ＡＢ Straße") = "ab strasse")
	check("utf8proc_NFC keeps char(0)", utf8proc_NFC("a" + char(0) + "b") = "a" + char(0) + "b")
	check("utf8proc_NFC empty string", utf8proc_NFC("") = "")
	check("utf8proc_map casefold", utf8proc_map("ÀB", UTF8PROC_COMPOSE | UTF8PROC_CASEFOLD) = "àb")
	check("utf8proc_encode_char", utf8proc_encode_char(0x1F600) = "😀")
	check("utf8proc_iterate", listEqual(utf8proc_iterate("a€", 2), [0x20AC, 3]))
	check("utf8proc_iterate end", listEqual(utf8proc_iterate("a", 2), [-1, 0]))
	check("utf8proc_iterate invalid", utf8proc_iterate(cInvalid, 2)[2] = UTF8PROC_ERROR_INVALIDUTF8)
	check("utf8proc_codepoints", listEqual(utf8proc_codepoints("aé€"), [97, 233, 8364]))
	check("utf8proc_fromcodepoints", utf8proc_fromcodepoints([97, 233, 8364]) = "aé€")
	check("utf8proc_length", utf8proc_length("aé€😀") = 4)
	check("utf8proc_isvalid", utf8proc_isvalid("aé") and ! utf8proc_isvalid(cInvalid))
	check("utf8proc_strwidth", utf8proc_strwidth("日本ab") = 6)
	check("utf8proc_graphemes", listEqual(utf8proc_graphemes(cCombined + "x" + cFamily), [cCombined, "x", cFamily]))
	check("utf8proc_graphemecount", utf8proc_graphemecount("🇪🇬🇯🇵") = 2)
	check("utf8proc_upperstring", utf8proc_upperstring("éa ж") = "ÉA Ж")
	check("utf8proc_lowerstring", utf8proc_lowerstring("ÉA Ж") = "éa ж")
	check("utf8proc_titlestring", utf8proc_titlestring("hello wORLD don't") = "Hello World Don't")
	check("utf8proc_get_property", utf8proc_get_property(65)[:categorystring] = "Lu")
	check("utf8proc_decompose_char", listEqual(utf8proc_decompose_char(0xE9, UTF8PROC_DECOMPOSE), [0x65, 0x301]))
	check("utf8proc_grapheme_break_stateful", utf8proc_grapheme_break_stateful(0x61, 0x62, 0)[1] = 1)
	check("utf8proc_category", utf8proc_category(0x41) = UTF8PROC_CATEGORY_LU)
	check("utf8proc_tolower", utf8proc_tolower(0x41) = 0x61)
	check("utf8proc_charwidth", utf8proc_charwidth(0x4E00) = 2)
	check("utf8proc_titlestring apostrophes", utf8proc_titlestring("'hello' o'neil don’t") = "'Hello' O'neil Don’t")
	check("utf8proc_codepoint_valid out of range", ! utf8proc_codepoint_valid(-1) and ! utf8proc_codepoint_valid(0x110000))
	check("utf8proc_displaywidth", utf8proc_displaywidth("日本" + cFamily + cCombined) = 7)
	check("utf8proc_displaywidth flags", utf8proc_displaywidth("🇪🇬🇯🇵") = 4)
	check("utf8proc_displaywidth emoji selector", utf8proc_displaywidth("❤" + unicodeChar(0xFE0F)) = 2)
	check("utf8proc_truncatewidth", utf8proc_truncatewidth("a日本", 2) = "a")
	check("utf8proc_words", listEqual(utf8proc_words("Don't stop, l'été 42!"), ["Don't", "stop", "l'été", "42"]))
	check("utf8proc_words trailing apostrophe", listEqual(utf8proc_words("dogs' toys"), ["dogs", "toys"]))
	check("utf8proc_wrap spaces", listEqual(utf8proc_wrap("aa bb cc dd", 5), ["aa bb", "cc dd"]))
	check("utf8proc_wrap wide", listEqual(utf8proc_wrap("日本語の", 4), ["日本", "語の"]))
	check("utf8proc_wrap closing punctuation", listEqual(utf8proc_wrap("日本語。", 6), ["日本", "語。"]))
	check("utf8proc_wrap opening bracket", listEqual(utf8proc_wrap("日本「語」", 6), ["日本", "「語」"]))
	check("utf8proc_wrap long word",listEqual(utf8proc_wrap("abcdefg", 3), ["abc", "def", "g"]))
	check("utf8proc_wrap line breaks", listEqual(utf8proc_wrap("a" + nl + nl + "b", 5), ["a", "", "b"]))
	check("utf8proc_wrap empty", listEqual(utf8proc_wrap("", 5), [""]))
	check("utf8proc_trim", utf8proc_trim(unicodeChar(0x3000) + " " + char(9) + "ab c" + unicodeChar(0xA0) + nl) = "ab c")
	check("utf8proc_trimleft/trimright", utf8proc_trimleft("  a  ") = "a  " and utf8proc_trimright("  a  ") = "  a")
	check("utf8proc_trim only spaces", utf8proc_trim("  " + nl) = "" and utf8proc_trim("") = "")
	check("utf8proc_trim keeps a space with a mark", utf8proc_trim(" " + unicodeChar(0x301) + "x") = " " + unicodeChar(0x301) + "x")
	check("utf8proc_find", utf8proc_find(cFamily + " and 🇪🇬", "🇪🇬") = 7 and utf8proc_find("abc", "x") = 0 and utf8proc_find("abc", "") = 0)
	check("utf8proc_find whole clusters", utf8proc_find(cCombined, "e") = 0 and utf8proc_find(cFamily, "👩") = 0)
	check("utf8proc_replace", utf8proc_replace("a-b-c", "-", "+") = "a+b+c" and utf8proc_replace("aaa", "aa", "b") = "ba")
	check("utf8proc_replace whole clusters", utf8proc_replace(cCombined + "e", "e", "E") = cCombined + "E")
	check("utf8proc_replace char(0)", utf8proc_replace("a" + char(0) + "b", char(0), "-") = "a-b")
	check("utf8proc_replace empty old", utf8proc_replace("abc", "", "x") = "abc")
	check("utf8proc_replaceinvalid", utf8proc_replaceinvalid("a" + char(0xFF) + "b") = "a" + unicodeChar(0xFFFD) + "b")

	? "Errors"
	check("Invalid UTF-8 raises an error", raisesError('utf8proc_NFC("a" + char(0xFF))'))
	check("Invalid options raise an error", raisesError('utf8proc_map("text", UTF8PROC_COMPOSE | UTF8PROC_DECOMPOSE)'))
	check("Invalid codepoint raises an error", raisesError("utf8proc_encode_char(0xD800)"))
	check("Bad parameter type raises an error", raisesError("utf8proc_length(10)"))
	check("Codepoint out of range raises an error", raisesError("utf8proc_tolower(100000000000000000000)"))
	check("Negative codepoint raises an error", raisesError("utf8proc_category(-5)"))
	check("Find in invalid UTF-8 raises an error", raisesError('utf8proc_find("a" + char(0xFF), "a")'))
	check("Wrap width less than 1 raises an error", raisesError('utf8proc_wrap("text", 0)'))

	? "Library functions"
	check("unicodeEqual", unicodeEqual(cE, cCombined))
	check("unicodeEqualIgnoreCase", unicodeEqualIgnoreCase("ΣΟΦΙΑ", "σοφια"))
	check("unicodeNormalize", unicodeNormalize(cCombined, "nfc") = cE)
	check("unicodeIsNormalized", unicodeIsNormalized(cE, UNICODE_NFC) and ! unicodeIsNormalized(cE, UNICODE_NFD))
	check("unicodeCaseFold", unicodeCaseFold("Straße") = "strasse")
	check("unicodeStripMarks", unicodeStripMarks("Crème Brûlée") = "Creme Brulee")
	check("unicodeSlug", unicodeSlug("  Crème Brûlée — #1! ") = "creme-brulee-1")
	check("unicodeFixInvalid", unicodeFixInvalid(cInvalid) = "a" + unicodeChar(UNICODE_REPLACEMENTCHAR))
	check("unicodeWidth", unicodeWidth("日本" + cFamily + cCombined) = 7)
	check("unicodeTruncate", unicodeTruncate("日本語", 5) = "日本")
	check("unicodePadRight", unicodePadRight("日本", 6) = "日本  ")
	check("unicodePadLeft", unicodePadLeft("é", 3) = "  é")
	check("unicodeCenter", unicodeCenter("ab", 5) = " ab  ")
	check("unicodeReverse", unicodeReverse("a" + cCombined + cFamily) = cFamily + cCombined + "a")
	check("unicodeSubStr", unicodeSubStr("🇪🇬a🇯🇵b", 2, 2) = "a🇯🇵")
	check("unicodeLeft", unicodeLeft("日本語", 2) = "日本")
	check("unicodeRight", unicodeRight("日本語", 5) = "日本語")
	check("unicodeCode", unicodeCode("€") = 0x20AC)
	check("unicodeToHex", unicodeToHex("Aé") = "U+0041 U+00E9")
	check("unicodeCategory", unicodeCategory("ب") = "Lo")
	check("unicodeCategoryName", unicodeCategoryName(0x30) = "Number, decimal digit")
	check("unicodeIsLetter", unicodeIsLetter("ж") and ! unicodeIsLetter("1"))
	check("unicodeIsSpace", unicodeIsSpace(nl) and unicodeIsSpace(0x3000) and ! unicodeIsSpace("a"))
	check("unicodeIsUpper/IsLower", unicodeIsUpper("Ж") and unicodeIsLower("ж"))
	check("unicodeSlug apostrophes", unicodeSlug("Don't Stop") = "dont-stop")
	check("unicodeWordCount", unicodeWordCount("one, two; three") = 3)
	check("unicodeWrapText", unicodeWrapText("aa bb cc", 5) = "aa bb" + nl + "cc")
	check("unicodeSearchKey", unicodeSearchKey("Ｃａｆé") = "cafe")
	check("unicodeSearch", unicodeSearch("Crème Brûlée", "BRULEE") and ! unicodeSearch("abc", "x"))
	check("unicodeCompare", unicodeCompare("École", "ecole") = 0 and unicodeCompare("a", "B") = -1 and unicodeCompare("b", "A") = 1)
	check("unicodeSort", listEqual(unicodeSort(["b", "É", "a", "C"]), ["a", "b", "C", "É"]))

	? "UnicodeString class"
	oText = new UnicodeString("Crème Brûlée")
	check("value", oText.value() = "Crème Brûlée")
	check("codepointCount", oText.codepointCount() = 12)
	check("graphemeAt", oText.graphemeAt(3) = "è")
	check("chaining", oText.stripMarks().toUpper().value() = "CREME BRULEE")
	check("object keeps the result", oText.value() = "CREME BRULEE")
	check("equalsIgnoreCase", oText.equalsIgnoreCase("creme brulee"))
	check("contains", oText.contains("brulee"))
	check("compare", oText.compare("creme brulee") = 0)
	check("words", listEqual(oText.words(), ["CREME", "BRULEE"]) and oText.wordCount() = 2)
	check("wrap", listEqual(oText.wrap(6), ["CREME", "BRULEE"]))
	oSpaces = new UnicodeString("  a-b  ")
	check("trimSpaces and replaceText", oSpaces.trimSpaces().replaceText("-", "+").value() = "a+b" and oSpaces.findText("b") = 3)
	oEmpty = new UnicodeString("")
	check("isEmpty", oEmpty.isEmpty())

	? ""
	? "Passed: " + nTestsPassed + "  Failed: " + nTestsFailed

func check cName, lResult
	if lResult
		nTestsPassed++
		? "  [PASS] " + cName
	else
		nTestsFailed++
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
