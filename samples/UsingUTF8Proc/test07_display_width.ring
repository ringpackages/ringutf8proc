# Display width: aligning text that contains wide (East Asian) characters and emoji

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	aRows = [
		["Item",     "Language", "Price"],
		["Book",     "English",  "10"],
		["本",       "日本語",   "1200"],
		["책",       "한국어",   "15000"],
		["Café ☕",  "Français", "4"],
		["Pizza 🍕", "Italiano", "8"]
	]

	nCount = len(aRows)
	for x = 1 to nCount
		? "| " + unicodePadRight(aRows[x][1], 10) + " | " +
		  unicodeCenter(aRows[x][2], 10) + " | " +
		  unicodePadLeft(aRows[x][3], 6) + " |"
		if x = 1
			? "|" + copy("-", 12) + "|" + copy("-", 12) + "|" + copy("-", 8) + "|"
		ok
	next
	? ""

	aTexts = ["abc", "日本語", "😀", "e" + unicodeChar(0x301), "👨‍👩‍👧"]
	nCount = len(aTexts)
	for x = 1 to nCount
		? unicodePadRight(aTexts[x], 8) + " width: " + unicodeWidth(aTexts[x]) +
		  "  (sum of codepoint widths: " + utf8proc_strwidth(aTexts[x]) + ")"
	next
	? ""

	# Truncate to a number of columns without cutting a character
	cText = "日本語のテキスト"
	for nWidth = 3 to 8
		? "Width " + nWidth + " : [" + unicodeTruncate(cText, nWidth) + "]"
	next
