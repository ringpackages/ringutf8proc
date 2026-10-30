# Printing Arabic text in terminals that don't support right-to-left text (like Windows Terminal)
# unicodeArabicVisual() shapes the letters and puts the text in visual order
# The same strings can be drawn by game engines (RayLib DrawTextEx(), SDL_ttf, Allegro) using an Arabic font

load "utf8proclib.ring"

func main
	unicodeSetupVisualConsole()

	? "Logical order (correct only in terminals that support right-to-left text):"
	? "   مرحبا بالعالم"
	? "Visual order (correct in terminals that don't reorder right-to-left text):"
	? "   " + unicodeArabicVisual("مرحبا بالعالم")
	? ""

	# Right aligned lines in a box (right-to-left text starts on the right)
	cParagraph = "لغة رينج هي لغة برمجة عملية متعددة الأغراض، تدعم البرمجة الإجرائية والكائنية والوظيفية."
	nWidth = 30
	aLines = unicodeArabicVisualWrap(cParagraph, nWidth)
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
	? "| No | English  | " + unicodePadLeft(unicodeArabicVisual("عربي"), 8) + " |"
	? "|----|----------|----------|"
	nCount = len(aRows)
	for x = 1 to nCount
		? "| " + unicodePadRight(aRows[x][1], 2) + " | " + unicodePadRight(aRows[x][2], 8) + " | " +
		  unicodePadLeft(unicodeArabicVisual(aRows[x][3]), 8) + " |"
	next
	? ""

	# Mixed text and numbers
	? unicodeArabicVisual("الإصدار 1.28 من لغة Ring")
	? unicodeArabicVisual("السعر: ١٢٠ ريال (شامل الضريبة)")
