# Bidirectional text: from logical order (the order of reading) to visual order (left to right on the screen)

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	# The codepoints show the order without depending on how the terminal displays them
	aTexts = [
		"Ring",
		"مرحبا",
		"Ring لغة برمجة",
		"لغة Ring للبرمجة",
		"السعر 120 ريال",
		"السعر ١٢٠ ريال",
		"خصم 10%",
		"نص (مثال) [1]",
		"كَتَبَ"
	]
	nCount = len(aTexts)
	for x = 1 to nCount
		cText = aTexts[x]
		? "Logical : " + unicodeToHex(cText)
		? "Visual  : " + unicodeToHex(unicodeBidiVisual(cText))
		? ""
	next

	# The direction of a line comes from its first strong character, or it can be given
	cText = "123 abc"
	? "Auto : " + unicodeBidiVisual(cText)
	? "RTL  : " + unicodeBidiVisualDirection(cText, UNICODE_DIRECTION_RTL)
	? "LTR  : " + unicodeBidiVisualDirection("مرحبا", UNICODE_DIRECTION_LTR) + "  (one RTL run is reversed in any direction)"
	? ""

	# Each line is reordered alone
	cLines = "Line 1: English" + nl + "السطر 2: عربي" + nl + "Line 3"
	aVisual = str2list(unicodeBidiVisual(cLines))
	nCount = len(aVisual)
	for x = 1 to nCount
		? "Line " + x + " : " + unicodeToHex(aVisual[x])
	next
	? ""

	# The marks stay after their letters, and the brackets are mirrored in right-to-left text
	cText = "(كَتَبَ)"
	? "Logical : " + unicodeToHex(cText)
	? "Visual  : " + unicodeToHex(unicodeBidiVisual(cText))
