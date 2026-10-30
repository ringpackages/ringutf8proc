# Cleaning text: removing accents, lumping similar characters and creating slugs

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	? "Strip marks : " + unicodeStripMarks("Crème brûlée à la française, Ångström, naïve")
	? "Lump        : " + unicodeLump("Text ‐ with – dashes − and ‘quotes’")
	? "Controls    : [" + unicodeStripControls("Line 1" + nl + "Line 2" + char(9) + "Tab" + char(7)) + "]"

	cHidden = "soft" + unicodeChar(0xAD) + "hyphen zero" + unicodeChar(0x200B) + "width"
	cVisible = unicodeRemoveIgnorable(cHidden)
	? "Ignorable   : " + len(cHidden) + " bytes => " + cVisible + " (" + len(cVisible) + " bytes)"
	? ""

	aTitles = [
		"Hello World!",
		"Crème Brûlée — Recipe #1",
		"Ｒｉｎｇ Ｌａｎｇｕａｇｅ ① ② ③",
		"  Ελληνικά & Москва  ",
		"Ünïcödé   Slugs?!"
	]
	nCount = len(aTitles)
	for x = 1 to nCount
		? "Slug: " + unicodeSlug(aTitles[x])
	next
