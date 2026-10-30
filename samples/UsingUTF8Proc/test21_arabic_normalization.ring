# Arabic normalization: Alef forms, Tatweel, presentation forms and ligatures

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	# The Alef forms (with Hamza above, Hamza below, Madda and Wasla) become Alef
	? "Alef forms"
	aWords = ["أسد", "إناء", "آلة", "ٱلكتاب"]
	nCount = len(aWords)
	for x = 1 to nCount
		? "   " + unicodePadRight(aWords[x], 8) + " => " + unicodeArabicNormalizeAlef(aWords[x]) +
		  "   " + unicodeToHex(left(aWords[x], 2))
	next
	? ""

	# Tatweel (Kashida) stretches the words
	cStretched = "جمـــيل جـدا"
	? "Tatweel    : " + cStretched + " => " + unicodeArabicRemoveTatweel(cStretched)
	? ""

	# Presentation forms (the shaped letters stored in old documents) and ligatures
	cShaped = unicodeFromCodepoints([0xFEE3, 0xFEAE, 0xFEA3, 0xFE92, 0xFE8E])
	? "Presentation forms : " + unicodeToHex(cShaped)
	? "After normalize    : " + unicodeArabicNormalize(cShaped) + "  " + unicodeToHex(unicodeArabicNormalize(cShaped))
	? "Lam-Alef ligature  : " + unicodeToHex(unicodeChar(0xFEFB)) + " => " + unicodeArabicNormalize(unicodeChar(0xFEFB))
	? "Allah ligature     : " + unicodeToHex(unicodeChar(0xFDF2)) + " => " + unicodeArabicNormalize(unicodeChar(0xFDF2))
	? ""

	# unicodeArabicNormalize() does all the steps: NFKC, Tashkeel, Tatweel and Alef forms
	aTexts = [
		"إِنَّ الْعِلْمَ نُــــورٌ",
		"ﻣﺮﺣﺒﺎ بالأصدقاء",
		"ٱلْحَمْدُ لِلَّهِ"
	]
	nCount = len(aTexts)
	for x = 1 to nCount
		? "Text       : " + aTexts[x]
		? "Normalized : " + unicodeArabicNormalize(aTexts[x])
	next
	? ""

	# unicodeArabicSearchKey() also unifies the letters that are often written in different ways
	aPairs = [
		["مدرسة", "مدرسه"],
		["مستشفى", "مستشفي"],
		["سؤال", "سوال"],
		["شاطئ", "شاطي"],
		["أَسَد", "اسد"]
	]
	? "Search keys"
	nCount = len(aPairs)
	for x = 1 to nCount
		cWord1 = aPairs[x][1]
		cWord2 = aPairs[x][2]
		? "   " + unicodePadRight(cWord1, 8) + unicodePadRight(cWord2, 8) +
		  "equal: " + (unicodeArabicSearchKey(cWord1) = unicodeArabicSearchKey(cWord2)) +
		  "  key: " + unicodeArabicSearchKey(cWord1)
	next
