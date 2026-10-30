# Sorting and searching that ignore case, accents and width differences

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	aNames = ["zebra", "Éclair", "apple", "Ünïcode", "banana", "éclair", "Apple", "ＡＢＣ", "Ångström", "cherry"]

	# The Ring sort() function compares bytes: upper case before lower case, accents at the end
	? "sort()        : " + joinList(sort(aNames))

	# unicodeSort() compares the search keys (case folded, without marks, NFKC)
	? "unicodeSort() : " + joinList(unicodeSort(aNames))
	? ""

	# unicodeCompare() returns -1, 0 or 1
	aPairs = [["École", "ecole"], ["apple", "Banana"], ["Zoë", "zoe"], ["b", "A"]]
	nCount = len(aPairs)
	for x = 1 to nCount
		? "unicodeCompare(" + aPairs[x][1] + ", " + aPairs[x][2] + ") = " +
		  unicodeCompare(aPairs[x][1], aPairs[x][2])
	next
	? ""

	# unicodeSearch() finds text ignoring case, accents and width
	cText = "Crème Brûlée and Café au lait at the ＣＡＦＥ"
	aQueries = ["BRULEE", "cafe", "creme", "tea"]
	nCount = len(aQueries)
	for x = 1 to nCount
		? "Search '" + aQueries[x] + "' : " + unicodeSearch(cText, aQueries[x])
	next
	? "Search key : " + unicodeSearchKey(cText)
	? ""

	# The UnicodeString class
	oText = new UnicodeString("Ångström units")
	? "contains('ANGSTROM') : " + oText.contains("ANGSTROM")
	? "compare('angstrom units') : " + oText.compare("angstrom units")

func joinList aList
	cResult = ""
	nCount = len(aList)
	for x = 1 to nCount
		if x > 1
			cResult += ", "
		ok
		cResult += aList[x]
	next
	return cResult
