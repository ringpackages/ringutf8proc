# Arabic words, word frequency and line wrapping
# Note: the lines are printed in logical order; terminals that support bidirectional text show them right to left

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	# Words: the Arabic punctuation (، ؛ ؟) separates the words, the Tashkeel stays in the words
	cText = "قالَ المعلمُ: العلمُ نورٌ، والجهلُ ظلامٌ؛ فهل تحبُّ القراءةَ؟ نعم!"
	aWords = unicodeWords(cText)
	? "Text  : " + cText
	? "Words : " + unicodeWordCount(cText)
	nCount = len(aWords)
	for x = 1 to nCount
		? "   " + x + " : " + aWords[x]
	next
	? ""

	# Word frequency (the words are compared without Tashkeel)
	cParagraph = "الكتابُ صديقٌ، الكتاب معلمٌ، اقرأ الكتاب كل يوم، القراءة غذاء العقل، والعقل يحب القِراءة."
	aWords = unicodeWords(cParagraph)
	aCounts = []
	nCount = len(aWords)
	for x = 1 to nCount
		cKey = unicodeArabicSearchKey(aWords[x])
		nPos = 0
		nItems = len(aCounts)
		for y = 1 to nItems
			if aCounts[y][1] = cKey
				nPos = y
				exit
			ok
		next
		if nPos = 0
			aCounts + [cKey, 1]
		else
			aCounts[nPos][2]++
		ok
	next
	aCounts = sort(aCounts, 2)
	? "Most used words:"
	for x = len(aCounts) to len(aCounts) - 2 step -1
		? "   " + aCounts[x][1] + " : " + aCounts[x][2]
	next
	? ""

	# Wrap an Arabic paragraph by display width (the Tashkeel uses no columns)
	cParagraph = "إِنَّ اللُّغَةَ العَرَبِيَّةَ مِنْ أَقْدَمِ اللُّغَاتِ، وَهِيَ لُغَةٌ غَنِيَّةٌ بِالْمُفْرَدَاتِ وَالتَّرَاكِيبِ."
	nWidth = 20
	aLines = unicodeWrap(cParagraph, nWidth)
	? "Wrapped to " + nWidth + " columns:"
	nCount = len(aLines)
	for x = 1 to nCount
		? "   [" + aLines[x] + "] width: " + unicodeWidth(aLines[x])
	next
	? ""

	# Truncate an Arabic title for a narrow column
	cTitle = "مُقَدِّمَةٌ فِي عِلْمِ الحاسوب"
	for nWidth = 6 to 14 step 4
		? "Truncate to " + nWidth + " : " + unicodeTruncate(cTitle, nWidth)
	next
