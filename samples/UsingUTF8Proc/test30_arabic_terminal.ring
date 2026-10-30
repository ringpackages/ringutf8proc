# Printing Arabic text in terminals that don't support right-to-left text (like Windows Terminal)
# unicodeArabicConsole() shapes the letters, puts the text in visual order, and avoids the false
# Lam-Alef ligatures that these terminals make (for game engines use unicodeArabicVisual())

load "utf8proclib.ring"

func main
	unicodeSetupVisualConsole()

	? "Logical order (correct only in terminals that support right-to-left text):"
	? "   مرحبا بالعالم"
	? "Visual order (correct in terminals that don't reorder right-to-left text):"
	? "   " + unicodeArabicConsole("مرحبا بالعالم")
	? ""

	# Right aligned lines in a box (right-to-left text starts on the right)
	cParagraph = "لغة رينج هي لغة برمجة عملية متعددة الأغراض، تدعم البرمجة الإجرائية والكائنية والوظيفية."
	nWidth = 30
	aLines = unicodeArabicConsoleWrap(cParagraph, nWidth)
	? "+" + copy("-", nWidth + 2) + "+"
	nCount = len(aLines)
	for x = 1 to nCount
		? "| " + unicodePadLeft(aLines[x], nWidth) + " |"
	next
	? "+" + copy("-", nWidth + 2) + "+"
	? ""

	# A table with an Arabic column
	aRows = [
		["1", "Book", "كتاب"],
		["2", "Pen", "قلم"],
		["3", "School", "مدرسة"],
		["4", "Library", "مكتبة"]
	]
	? "| No | English  | " + unicodePadLeft(unicodeArabicConsole("عربي"), 8) + " |"
	? "|----|----------|----------|"
	nCount = len(aRows)
	for x = 1 to nCount
		? "| " + unicodePadRight(aRows[x][1], 2) + " | " + unicodePadRight(aRows[x][2], 8) + " | " +
		  unicodePadLeft(unicodeArabicConsole(aRows[x][3]), 8) + " |"
	next
	? ""

	# Mixed text and numbers
	? unicodeArabicConsole("الإصدار 1.28 من لغة Ring")
	? unicodeArabicConsole("السعر: ١٢٠ ريال (شامل الضريبة)")
	? ""

	# Words where Alef comes before Lam (visual order puts a Lam form before the Alef)
	? unicodeArabicConsole("بالعالم فالكتاب كالقمر سالم مآل وإلى عالم")
	? unicodeArabicConsole("لا سلام الأول إلى لأن")
