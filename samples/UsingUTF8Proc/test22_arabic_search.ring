# Arabic search that ignores Tashkeel, Tatweel, Hamza forms, Teh Marbuta, Alef Maksura and digit forms

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	aBooks = [
		"مُقَدِّمَةٌ فِي عِلْمِ الحاسوب",
		"تعلم البرمجة بلغة رينج",
		"الرياضيات للمدرسة الإعدادية",
		"دليل المكتبــة العامة",
		"أساسيات الذكاء الاصطناعي",
		"قصص قصيرة للأطفال - الجزء ٢",
		"كتاب الطبخ: مائة وصفة",
		"اللغة العربية للمستوى الأول"
	]

	# Build the search keys once
	aKeys = []
	nCount = len(aBooks)
	for x = 1 to nCount
		aKeys + unicodeArabicSearchKey(aBooks[x])
	next

	aQueries = ["مقدمة", "مدرسه", "مكتبة", "اساسيات", "الجزء 2", "رينج", "الاول", "علوم"]
	nQueries = len(aQueries)
	for nQuery = 1 to nQueries
		cKey = unicodeArabicSearchKey(aQueries[nQuery])
		? "Search: " + aQueries[nQuery]
		lFound = False
		for x = 1 to nCount
			if substr(aKeys[x], cKey) > 0
				? "   " + aBooks[x]
				lFound = True
			ok
		next
		if ! lFound
			? "   (no results)"
		ok
	next
	? ""

	# Search in one text using unicodeArabicSearch()
	cText = "ذَهَبْتُ إِلَى المَدْرَسَةِ فِي الصَّبَاحِ"
	? "Text : " + cText
	? "Contains 'المدرسه'  : " + unicodeArabicSearch(cText, "المدرسه")
	? "Contains 'الى'      : " + unicodeArabicSearch(cText, "الى")
	? "Contains 'المساء'   : " + unicodeArabicSearch(cText, "المساء")
	? ""

	# unicodeFind() and unicodeReplace() work on exact text (whole characters)
	cText = "العلم نور والجهل ظلام"
	? "Text                     : " + cText
	? "unicodeFind('نور')       : " + unicodeFind(cText, "نور")
	? "unicodeReplace(نور, ضياء) : " + unicodeReplace(cText, "نور", "ضياء")
