class UnicodeString

	# The UTF-8 text (transform methods change it and return self, so calls can be chained)
	cText = ""

	func init cValue
		setValue(cValue)
		return self

	func setValue cValue
		if ! isString(cValue)
			raise(UNICODE_ERRORPREFIX + "UnicodeString expects a string")
		ok
		cText = cValue
		return self

	func value
		return cText

	# Information

	func byteCount
		return len(cText)

	func codepointCount
		return utf8proc_length(cText)

	func graphemeCount
		return utf8proc_graphemecount(cText)

	func width
		return unicodeWidth(cText)

	func isValid
		return utf8proc_isvalid(cText)

	func isEmpty
		return cText = ""

	func isNormalized cForm
		return unicodeIsNormalized(cText, cForm)

	func equals cOther
		return unicodeEqual(cText, cOther)

	func equalsIgnoreCase cOther
		return unicodeEqualIgnoreCase(cText, cOther)

	# Parts

	func graphemes
		return utf8proc_graphemes(cText)

	func codepoints
		return utf8proc_codepoints(cText)

	func graphemeAt nIndex
		return unicodeSubStr(cText, nIndex, 1)

	func subString nStart, nCount
		return unicodeSubStr(cText, nStart, nCount)

	func toHex
		return unicodeToHex(cText)

	func words
		return utf8proc_words(cText)

	func wordCount
		return len(utf8proc_words(cText))

	func wrap nWidth
		return utf8proc_wrap(cText, nWidth)

	func contains cQuery
		return unicodeSearch(cText, cQuery)

	func compare cOther
		return unicodeCompare(cText, cOther)

	func findText cSubStr
		return utf8proc_find(cText, cSubStr)

	func hasArabic
		return unicodeHasArabic(cText)

	func info
		return unicodeInfo(cText)

	# Transformations (return self)

	func toNFC
		cText = utf8proc_NFC(cText)
		return self

	func toNFD
		cText = utf8proc_NFD(cText)
		return self

	func toNFKC
		cText = utf8proc_NFKC(cText)
		return self

	func toNFKD
		cText = utf8proc_NFKD(cText)
		return self

	func toUpper
		cText = utf8proc_upperstring(cText)
		return self

	func toLower
		cText = utf8proc_lowerstring(cText)
		return self

	func toTitle
		cText = utf8proc_titlestring(cText)
		return self

	func toCaseFold
		cText = unicodeCaseFold(cText)
		return self

	func toReversed
		cText = unicodeReverse(cText)
		return self

	func toSlug
		cText = unicodeSlug(cText)
		return self

	func stripMarks
		cText = unicodeStripMarks(cText)
		return self

	func stripControls
		cText = unicodeStripControls(cText)
		return self

	func fixInvalid
		cText = unicodeFixInvalid(cText)
		return self

	func trimSpaces
		cText = utf8proc_trim(cText)
		return self

	func replaceText cOld, cNew
		cText = utf8proc_replace(cText, cOld, cNew)
		return self

	func arabicNormalize
		cText = unicodeArabicNormalize(cText)
		return self

	func arabicStripTashkeel
		cText = unicodeArabicStripTashkeel(cText)
		return self

	func toArabicDigits
		cText = unicodeArabicDigits(cText)
		return self

	func toAsciiDigits
		cText = utf8proc_asciidigits(cText)
		return self

	func arabicShape
		cText = utf8proc_arabicshape(cText)
		return self

	func arabicVisual
		cText = unicodeArabicVisual(cText)
		return self

	func arabicConsole
		cText = unicodeArabicConsole(cText)
		return self

	func bidiVisual
		cText = unicodeBidiVisual(cText)
		return self

	func truncate nWidth
		cText = unicodeTruncate(cText, nWidth)
		return self

	func padRight nWidth
		cText = unicodePadRight(cText, nWidth)
		return self

	func padLeft nWidth
		cText = unicodePadLeft(cText, nWidth)
		return self

	func center nWidth
		cText = unicodeCenter(cText, nWidth)
		return self
