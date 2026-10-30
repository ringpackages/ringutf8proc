# Arabic-Indic and Persian digits

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	# Convert between the digit forms
	cText = "الصفحة 15 من 230 - سنة 2026"
	? "ASCII digits         : " + cText
	? "Arabic-Indic digits  : " + unicodeArabicDigits(cText)
	? "Persian/Urdu digits  : " + unicodePersianDigits(cText)
	? "Back to ASCII digits : " + unicodeAsciiDigits(unicodeArabicDigits(cText))
	? ""

	# unicodeAsciiDigits() converts the decimal digits of all the scripts
	aNumbers = ["٠١٢٣٤٥٦٧٨٩", "۰۱۲۳۴۵۶۷۸۹", "०१२३४५६७८९", "০১২৩৪৫৬৭৮৯", "０１２３４５６７８９"]
	nCount = len(aNumbers)
	for x = 1 to nCount
		? unicodePadRight(aNumbers[x], 12) + " => " + unicodeAsciiDigits(aNumbers[x])
	next
	? ""

	# Calculations with numbers written in Arabic-Indic digits
	cPrice = "١٢٥"
	cCount = "٤"
	nTotal = number(unicodeAsciiDigits(cPrice)) * number(unicodeAsciiDigits(cCount))
	? "Price " + cPrice + " x " + cCount + " = " + unicodeArabicDigits("" + nTotal)
	? ""

	# Sum of the numbers in an Arabic sentence
	cSentence = "اشتريت ٣ كتب و١٢ قلما و٥ دفاتر"
	aWords = unicodeWords(unicodeAsciiDigits(cSentence))
	nSum = 0
	nWords = len(aWords)
	for x = 1 to nWords
		if isdigit(aWords[x])
			nSum += number(aWords[x])
		else
			# Words like "و12" start with a letter
			cDigits = ""
			nChars = len(aWords[x])
			for y = 1 to nChars
				if isdigit(aWords[x][y])
					cDigits += aWords[x][y]
				ok
			next
			if cDigits != ""
				nSum += number(cDigits)
			ok
		ok
	next
	? "Sentence : " + cSentence
	? "Sum      : " + unicodeArabicDigits("" + nSum)
	? ""

	# The value of one digit
	aDigits = ["٧", "۸", "३", "9", "ب"]
	nCount = len(aDigits)
	for x = 1 to nCount
		? "unicodeDigitValue(" + aDigits[x] + ") = " + unicodeDigitValue(aDigits[x]) +
		  "   " + unicodeToHex(aDigits[x]) + "  " + unicodeCategory(aDigits[x])
	next
