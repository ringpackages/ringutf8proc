# Words and line wrapping by display width

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	# Words are runs of letters, marks and numbers (an apostrophe inside a word is kept)
	cText = "Don't stop: l'été, 2026 — naïve café!"
	aWords = unicodeWords(cText)
	? "Text  : " + cText
	? "Words : " + unicodeWordCount(cText)
	nCount = len(aWords)
	for x = 1 to nCount
		? "   " + x + " : " + aWords[x]
	next
	? ""

	# Wrap text to a number of columns
	cText = "Unicode text processing in Ring: normalization, case mapping, " +
		"grapheme clusters and display width for terminals."
	showBox(cText, 24)

	# East Asian text has no spaces: lines break between the wide characters
	showBox("日本語のテキストは、スペースがなくても折り返すことができます。", 20)

	# Mixed text, emoji and explicit line breaks
	showBox("Emoji 👨‍👩‍👧 and flags 🇪🇬🇯🇵 keep their width." + nl + "Second paragraph.", 16)

	# A word longer than the line is split between characters
	showBox("Supercalifragilisticexpialidocious", 12)

	# unicodeWrapText() returns one string
	? unicodeWrapText("Short lines from a long sentence of words.", 15)

func showBox cText, nWidth
	aLines = unicodeWrap(cText, nWidth)
	? "+" + copy("-", nWidth + 2) + "+"
	nCount = len(aLines)
	for x = 1 to nCount
		? "| " + unicodePadRight(aLines[x], nWidth) + " |"
	next
	? "+" + copy("-", nWidth + 2) + "+"
	? ""
