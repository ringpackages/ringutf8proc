# Arabic shaping: presentation forms and Lam-Alef ligatures
# For renderers that draw each codepoint alone (game engines, simple PDF writers)

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	# The four forms of the letters (the table is built from the Unicode data)
	aLetters = ["ب", "ج", "س", "ع", "ه", "ي", "ا", "د", "ر", "و", "ء", "پ", "گ", "ی"]
	? unicodePadRight("Letter", 8) + unicodePadRight("Joining", 10) + unicodePadRight("Isolated", 10) +
	  unicodePadRight("Final", 10) + unicodePadRight("Initial", 10) + "Medial"
	? copy("-", 58)
	aJoiningNames = ["None", "Right", "Dual", "Causing", "Transparent"]
	nCount = len(aLetters)
	for x = 1 to nCount
		cLetter = aLetters[x]
		cLine = unicodePadRight(cLetter, 8) + unicodePadRight(aJoiningNames[unicodeArabicJoiningType(cLetter) + 1], 10)
		for nForm = UNICODE_FORM_ISOLATED to UNICODE_FORM_MEDIAL
			nCode = unicodeArabicForm(cLetter, nForm)
			if nCode = 0
				cLine += unicodePadRight("-", 10)
			else
				cLine += unicodePadRight(unicodeToHex(unicodeChar(nCode)), 10)
			ok
		next
		? cLine
	next
	? ""

	# Shaping words: each letter gets the form that connects it to its neighbors
	aWords = ["مرحبا", "سلام", "الله", "علاقة", "لأن", "كَتَبَ", "بـــاب", "پیچ"]
	nCount = len(aWords)
	for x = 1 to nCount
		? unicodePadRight(aWords[x], 8) + unicodePadRight(unicodeToHex(aWords[x]), 44) + " =>"
		? "        " + unicodeToHex(unicodeArabicShape(aWords[x]))
	next
	? ""

	# Shaping keeps the text: NFKC gives back the letters
	cText = "مرحبا بالعالم"
	cShaped = unicodeArabicShape(cText)
	? "Shaped text      : " + cShaped
	? "Codepoints       : " + unicodeLength(cText) + " => " + unicodeLength(cShaped)
	? "NFKC gives back  : " + (unicodeNFKC(cShaped) = cText)
	? "Normalize equals : " + (unicodeArabicNormalize(cShaped) = unicodeArabicNormalize(cText))
