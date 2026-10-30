# The UnicodeString class: chain transformations on a string

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	oText = new UnicodeString("Crème Brûlée 🍮 Recipe")

	? "Value      : " + oText.value()
	? "Bytes      : " + oText.byteCount()
	? "Codepoints : " + oText.codepointCount()
	? "Graphemes  : " + oText.graphemeCount()
	? "Width      : " + oText.width()
	? "Valid      : " + oText.isValid()
	? "Grapheme 14: " + oText.graphemeAt(14)
	? "SubString  : " + oText.subString(7, 6)
	? ""

	# Transformations change the text and return the object
	? "Upper      : " + oText.toUpper().value()
	? "Title      : " + oText.toTitle().value()
	? "No marks   : " + oText.stripMarks().value()
	? "Slug       : " + oText.toSlug().value()
	? ""

	oName = new UnicodeString("ﬁnal ＲＥＰＯＲＴ")
	? "Equals 'final report' (ignore case) : " + oName.equalsIgnoreCase("final report")
	? "NFKC + lower : " + oName.toNFKC().toLower().value()
	? ""

	oCell = new UnicodeString("日本語テキスト")
	? "[" + oCell.truncate(8).padRight(10).value() + "]"
