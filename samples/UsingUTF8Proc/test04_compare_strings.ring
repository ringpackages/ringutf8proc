# Comparing strings: exact, canonical (NFC) and case-insensitive

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	aPairs = [
		["Ring", "Ring"],
		["Ring", "RING"],
		["Café", "Cafe" + unicodeChar(0x301)],
		["Straße", "STRASSE"],
		["ﬁle", "FILE"],
		["ΣΟΦΙΑ", "σοφια"],
		["Ｒｉｎｇ", "ring"],
		["apple", "orange"]
	]

	? unicodePadRight("Text 1", 10) + unicodePadRight("Text 2", 12) + unicodePadRight("Exact", 8) +
	  unicodePadRight("Equal", 8) + "Ignore Case"
	? copy("-", 50)
	nCount = len(aPairs)
	for x = 1 to nCount
		cText1 = aPairs[x][1]
		cText2 = aPairs[x][2]
		? unicodePadRight(cText1, 10) + unicodePadRight(cText2, 12) +
		  unicodePadRight("" + (cText1 = cText2), 8) +
		  unicodePadRight("" + unicodeEqual(cText1, cText2), 8) +
		  unicodeEqualIgnoreCase(cText1, cText2)
	next
