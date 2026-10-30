# Unit tests for Arabic shaping, visual order, scripts and the utility functions

load "utf8proclib.ring"

nShapingTestsPassed = 0
nShapingTestsFailed = 0

func main
	unicodeSetupConsole()

	? "Joining types and forms"
	check("Dual joining (Beh)", unicodeArabicJoiningType("ب") = UNICODE_JOIN_DUAL)
	check("Right joining (Alef, Dal, Reh, Waw)", unicodeArabicJoiningType("ا") = UNICODE_JOIN_RIGHT and unicodeArabicJoiningType("د") = UNICODE_JOIN_RIGHT and
	      unicodeArabicJoiningType("ر") = UNICODE_JOIN_RIGHT and unicodeArabicJoiningType("و") = UNICODE_JOIN_RIGHT)
	check("Non joining (Hamza, Latin, ZWNJ)", unicodeArabicJoiningType("ء") = UNICODE_JOIN_NONE and unicodeArabicJoiningType("a") = UNICODE_JOIN_NONE and
	      unicodeArabicJoiningType(0x200C) = UNICODE_JOIN_NONE)
	check("Join causing (Tatweel, ZWJ)", unicodeArabicJoiningType("ـ") = UNICODE_JOIN_CAUSING and unicodeArabicJoiningType(0x200D) = UNICODE_JOIN_CAUSING)
	check("Transparent (Tashkeel)", unicodeArabicJoiningType(0x64E) = UNICODE_JOIN_TRANSPARENT and unicodeArabicJoiningType(0x651) = UNICODE_JOIN_TRANSPARENT)
	check("Persian letters are dual joining", unicodeArabicJoiningType("پ") = UNICODE_JOIN_DUAL and unicodeArabicJoiningType("ی") = UNICODE_JOIN_DUAL)
	check("Forms of Beh", unicodeArabicForm("ب", UNICODE_FORM_ISOLATED) = 0xFE8F and unicodeArabicForm("ب", UNICODE_FORM_FINAL) = 0xFE90 and
	      unicodeArabicForm("ب", UNICODE_FORM_INITIAL) = 0xFE91 and unicodeArabicForm("ب", UNICODE_FORM_MEDIAL) = 0xFE92)
	check("Alef has no initial form", unicodeArabicForm("ا", UNICODE_FORM_INITIAL) = 0 and unicodeArabicForm("ا", UNICODE_FORM_FINAL) = 0xFE8E)
	check("Forms of composed letters (Alef with Madda)", unicodeArabicForm("آ", UNICODE_FORM_ISOLATED) = 0xFE81)
	check("No forms for Latin letters", unicodeArabicForm("a", UNICODE_FORM_ISOLATED) = 0)
	check("Form number out of range", unicodeArabicForm("ب", 9) = 0)

	? "Shaping"
	check("Initial, final, initial, medial, final", unicodeToHex(unicodeArabicShape("مرحبا")) = "U+FEE3 U+FEAE U+FEA3 U+FE92 U+FE8E")
	check("Lam-Alef final", unicodeToHex(unicodeArabicShape("سلام")) = "U+FEB3 U+FEFC U+FEE1")
	check("Lam-Alef with Hamza isolated", unicodeToHex(unicodeArabicShape("لأن")) = "U+FEF7 U+FEE5")
	check("Lam-Alef with Madda and with Hamza below", unicodeToHex(unicodeArabicShape("لآ لإ")) = "U+FEF5 U+0020 U+FEF9")
	check("Lam Lam Heh (no ligature)", unicodeToHex(unicodeArabicShape("الله")) = "U+FE8D U+FEDF U+FEE0 U+FEEA")
	check("Tashkeel is kept and skipped", unicodeToHex(unicodeArabicShape("كَتَبَ")) = "U+FEDB U+064E U+FE98 U+064E U+FE90 U+064E")
	check("Mark between Lam and Alef", unicodeToHex(unicodeArabicShape("لَا")) = "U+FEFB U+064E")
	check("Tatweel joins", unicodeToHex(unicodeArabicShape("بـ")) = "U+FE91 U+0640")
	check("ZWJ joins", unicodeToHex(unicodeArabicShape("ب" + unicodeChar(0x200D))) = "U+FE91 U+200D")
	check("ZWNJ doesn't join", unicodeToHex(unicodeArabicShape("ب" + unicodeChar(0x200C) + "ب")) = "U+FE8F U+200C U+FE8F")
	check("Words are shaped alone", unicodeToHex(unicodeArabicShape("ب ب")) = "U+FE8F U+0020 U+FE8F")
	check("Persian", unicodeToHex(unicodeArabicShape("پیچ")) = "U+FB58 U+FBFF U+FB7B")
	check("Latin text is not changed", unicodeArabicShape("Ring 1.28") = "Ring 1.28")
	check("Empty string", unicodeArabicShape("") = "")
	check("NFKC gives back the letters", unicodeNFKC(unicodeArabicShape("مرحبا بالعالم")) = "مرحبا بالعالم")
	check("Shaping invalid UTF-8 raises an error", raisesError('unicodeArabicShape("ب" + char(0xFF))'))

	? "Visual order"
	check("LTR text", unicodeBidiVisual("Ring 1.28") = "Ring 1.28")
	check("RTL text is reversed", unicodeBidiVisual("ابت") = "تبا")
	check("Marks stay after their letters", unicodeToHex(unicodeBidiVisual("بَت")) = "U+062A U+0628 U+064E")
	check("Numbers keep their order in RTL text", unicodeBidiVisual("رقم 120") = "120 مقر")
	check("Arabic-Indic numbers keep their order", unicodeBidiVisual("رقم ١٢٠") = "١٢٠ مقر")
	# After Arabic letters the digits are Arabic numbers (rule W2), so % is neutral and goes to the left (like in browsers)
	check("Percent sign after Arabic letters", unicodeBidiVisual("خصم 10%") = "%10 مصخ")
	check("Percent sign in LTR text", unicodeBidiVisual("10% off") = "10% off")
	check("Decimal number", unicodeBidiVisual("العدد 1.5") = "1.5 ددعلا")
	check("Latin word in RTL text", unicodeBidiVisual("لغة Ring للبرمجة") = "ةجمربلل Ring ةغل")
	check("Arabic word in LTR text", unicodeBidiVisual("Ring لغة") = "Ring ةغل")
	check("Brackets are mirrored", unicodeBidiVisual("(نص)") = "(صن)")
	check("Lines are reordered alone", unicodeBidiVisual("ab" + nl + "بت") = "ab" + nl + "تب")
	check("CR LF is kept", unicodeBidiVisual("بت" + char(13) + char(10) + "ab") = "تب" + char(13) + char(10) + "ab")
	check("Forced RTL direction", unicodeBidiVisualDirection("123 abc", UNICODE_DIRECTION_RTL) = "abc 123")
	check("Forced LTR direction", unicodeBidiVisualDirection("بت 12", UNICODE_DIRECTION_LTR) = "12 تب")
	check("Trailing spaces use the paragraph level", unicodeBidiVisual("بت  ") = "  تب")
	check("Emoji sequences are kept", unicodeBidiVisual("بت 👨‍👩‍👧") = "👨‍👩‍👧 تب")
	check("Visual order keeps the bytes", len(unicodeBidiVisual("Ring لغة (2026)")) = len("Ring لغة (2026)"))
	check("Empty string", unicodeBidiVisual("") = "")
	check("Bad direction raises an error", raisesError('unicodeBidiVisualDirection("a", 5)'))
	check("Visual order of invalid UTF-8 raises an error", raisesError('unicodeBidiVisual("a" + char(0xFF))'))

	? "Shaping and visual order"
	check("unicodeArabicVisual", unicodeToHex(unicodeArabicVisual("سلام")) = "U+FEE1 U+FEFC U+FEB3")
	check("unicodeArabicVisual mixed", unicodeArabicVisual("Ring لا") = "Ring " + unicodeChar(0xFEFB))
	check("unicodeArabicVisualWrap", len(unicodeArabicVisualWrap("هذا نص عربي طويل للتجربة", 10)) = 3)
	check("unicodeArabicVisualWrap lines fit", unicodeWidth(unicodeArabicVisualWrap("هذا نص عربي طويل للتجربة", 10)[1]) <= 10)

	? "Console output (Windows Terminal)"
	check("Final Alef after a Lam form becomes isolated", unicodeToHex(utf8proc_avoidligatures(unicodeFromCodepoints([0xFEDF, 0xFE8E]))) = "U+FEDF U+FE8D")
	check("Marks between them are skipped", unicodeToHex(utf8proc_avoidligatures(unicodeFromCodepoints([0xFEE0, 0x64E, 0xFE8E]))) = "U+FEE0 U+064E U+FE8D")
	check("Alef with Hamza and Madda forms", unicodeToHex(utf8proc_avoidligatures(unicodeFromCodepoints([0xFEDF, 0xFE84, 0xFEDF, 0xFE82]))) = "U+FEDF U+FE83 U+FEDF U+FE81")
	check("Final Alef after other letters is kept", unicodeToHex(utf8proc_avoidligatures(unicodeFromCodepoints([0xFE91, 0xFE8E]))) = "U+FE91 U+FE8E")
	check("unicodeArabicConsole of Alef + Lam words", unicodeToHex(unicodeArabicConsole("بالعالم")) = "U+FEE2 U+FEDF U+FE8D U+FECC U+FEDF U+FE8D U+FE91")
	check("unicodeArabicConsole keeps real Lam-Alef ligatures", unicodeToHex(unicodeArabicConsole("سلام")) = "U+FEE1 U+FEFC U+FEB3")
	check("unicodeArabicConsole keeps the size", len(unicodeArabicConsole("مرحبا بالعالم")) = len(unicodeArabicVisual("مرحبا بالعالم")))
	check("unicodeArabicConsoleWrap", len(unicodeArabicConsoleWrap("بالعالم فالكتاب كالقمر", 8)) = 3)
	check("Avoid ligatures of invalid UTF-8 raises an error", raisesError('utf8proc_avoidligatures("a" + char(0xFF))'))

	? "Scripts and utilities"
	check("unicodeScript", unicodeScript("a") = "Latin" and unicodeScript("ب") = "Arabic" and unicodeScript("Ж") = "Cyrillic" and
	      unicodeScript("日") = "Han" and unicodeScript("한") = "Hangul" and unicodeScript("α") = "Greek" and unicodeScript("א") = "Hebrew")
	check("unicodeScript of marks and digits", unicodeScript(0x64E) = "Arabic" and unicodeScript("٣") = "Arabic" and unicodeScript("3") = "Common")
	check("unicodeScript of punctuation and spaces", unicodeScript(" ") = "Common" and unicodeScript("!") = "Common" and unicodeScript("😀") = "Common")
	check("unicodeIsCJK", unicodeIsCJK("日") and unicodeIsCJK(0x20000) and ! unicodeIsCJK("a") and ! unicodeIsCJK("あ"))
	check("unicodeIsWide", unicodeIsWide("日") and unicodeIsWide("😀") and ! unicodeIsWide("a"))
	check("unicodeToHexBytes", unicodeToHexBytes("a€") = "61 E2 82 AC" and unicodeToHexBytes("") = "")
	check("unicodeInfo", substr(unicodeInfo("بَ"), "Characters: 1") > 0 and substr(unicodeInfo("بَ"), "D8 A8 D9 8E") > 0)
	check("unicodeInfo of invalid UTF-8", substr(unicodeInfo("a" + char(0xFF)), "61 FF") > 0)

	? "UnicodeString class"
	oText = new UnicodeString("سلام")
	check("arabicShape", unicodeToHex(oText.arabicShape().value()) = "U+FEB3 U+FEFC U+FEE1")
	oText = new UnicodeString("سلام")
	check("arabicVisual", unicodeToHex(oText.arabicVisual().value()) = "U+FEE1 U+FEFC U+FEB3")
	oText = new UnicodeString("ابت")
	check("bidiVisual", oText.bidiVisual().value() = "تبا")
	oConsole = new UnicodeString("بالعالم")
	check("arabicConsole", unicodeToHex(oConsole.arabicConsole().value()) = "U+FEE2 U+FEDF U+FE8D U+FECC U+FEDF U+FE8D U+FE91")
	check("info", substr(oText.info(), "Codepoints: 3") > 0)

	? ""
	? "Passed: " + nShapingTestsPassed + "  Failed: " + nShapingTestsFailed

func check cName, lResult
	if lResult
		nShapingTestsPassed++
		? "  [PASS] " + cName
	else
		nShapingTestsFailed++
		? "  [FAIL] " + cName
	ok

func raisesError cCode
	# eval() is used because a "call" instruction that runs different functions can call the wrong one
	try
		eval(cCode)
	catch
		return True
	done
	return False
