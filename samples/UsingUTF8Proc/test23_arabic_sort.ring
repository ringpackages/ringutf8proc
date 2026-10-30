# Sorting Arabic words

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	aWords = ["يوم", "إبرة", "باب", "أرض", "ابن", "آلة", "تفاح", "مَدْرَسَة", "ماء", "ﻻعب",
		  "ثلج", "جبل", "سـمـاء", "حديقة", "خبز", "دار", "ذهب", "رمل", "زيت", "شمس"]

	# Ring sort() compares bytes: the Hamza forms, the Tashkeel and the presentation forms go to wrong places
	showList("sort()", sort(aWords))

	# unicodeArabicSort() compares the Arabic search keys (the order of the Arabic alphabet)
	showList("unicodeArabicSort()", unicodeArabicSort(aWords))

	# Mixed Arabic and English list
	aMixed = ["كتاب", "Book", "قلم", "apple", "Zebra", "باب", "Égypte"]
	showList("unicodeArabicSort() mixed", unicodeArabicSort(aMixed))

	# unicodeArabicCompare() returns -1, 0 or 1
	aPairs = [["باب", "بيت"], ["مَدْرَسَة", "مدرسه"], ["ياء", "ألف"]]
	nCount = len(aPairs)
	for x = 1 to nCount
		? "unicodeArabicCompare(" + aPairs[x][1] + ", " + aPairs[x][2] + ") = " +
		  unicodeArabicCompare(aPairs[x][1], aPairs[x][2])
	next

func showList cTitle, aList
	? cTitle
	cLine = "   "
	nCount = len(aList)
	for x = 1 to nCount
		if x > 1
			cLine += " ، "
		ok
		cLine += aList[x]
	next
	? cLine
	? ""
