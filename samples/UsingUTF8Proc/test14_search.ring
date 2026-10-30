# Search that ignores case, accents and width differences

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	aItems = [
		"Café Latte",
		"CAFE MOCHA",
		"Crème Brûlée",
		"Iced Coffee",
		"Ｃａｆé Americano",
		"Green Tea",
		"Brulee Cake"
	]

	# Build the search keys once (case folded, without accents, NFKC)
	aKeys = []
	nCount = len(aItems)
	for x = 1 to nCount
		aKeys + unicodeSearchKey(aItems[x])
	next

	aQueries = ["cafe", "brûlée", "CRÈME", "tea"]
	nQueries = len(aQueries)
	for nQuery = 1 to nQueries
		cKey = unicodeSearchKey(aQueries[nQuery])
		? "Search: " + aQueries[nQuery]
		for x = 1 to nCount
			if substr(aKeys[x], cKey) > 0
				? "   " + aItems[x]
			ok
		next
	next

