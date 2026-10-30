# Arabic text: removing diacritics (Tashkeel) and normalizing presentation forms

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	# Text with Tashkeel (the diacritics are nonspacing marks)
	cText = "اَلسَّلَامُ عَلَيْكُمْ"
	cPlain = unicodeStripMarks(cText)
	? "Text          : " + cText
	? "Codepoints    : " + unicodeLength(cText) + "  Graphemes: " + unicodeGraphemeCount(cText)
	? "Without marks : " + cPlain
	? "Codepoints    : " + unicodeLength(cPlain)
	? "Same words    : " + unicodeEqual(cPlain, "السلام عليكم")
	? ""

	# Presentation forms (shaped letters) become the base letters using NFKC
	cShaped = unicodeFromCodepoints([0xFEE3, 0xFEAE, 0xFEA3, 0xFE92, 0xFE8E])
	? "Presentation forms : " + unicodeToHex(cShaped)
	? "After NFKC         : " + unicodeToHex(unicodeNFKC(cShaped))
	? ""

	# Arabic-Indic digits are decimal digits
	cDigits = "٠١٢٣٤٥٦٧٨٩"
	aCodes = unicodeCodepoints(cDigits)
	cWestern = ""
	nCount = len(aCodes)
	for x = 1 to nCount
		if unicodeIsDigit(aCodes[x])
			cWestern += (aCodes[x] - 0x660)
		ok
	next
	? "Arabic-Indic digits : " + cDigits + " => " + cWestern
	? "Category of Beh     : " + unicodeCategoryName("ب")
	? "Arabic letter (AL)  : " + (unicodeCharInfo("ب")[:bidiclass] = UTF8PROC_BIDI_CLASS_AL)
