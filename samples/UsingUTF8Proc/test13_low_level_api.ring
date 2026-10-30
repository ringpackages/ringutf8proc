# The utf8proc functions: map options, decomposition and grapheme breaks

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	# utf8proc_map() accepts any combination of the UTF8PROC_* options
	cText = "Ｈéllo" + nl + "Wörld ﬁ"
	? utf8proc_map(cText, UTF8PROC_COMPOSE | UTF8PROC_COMPAT)
	? utf8proc_map(cText, UTF8PROC_COMPOSE | UTF8PROC_COMPAT | UTF8PROC_CASEFOLD | UTF8PROC_STRIPMARK)
	? utf8proc_map(cText, UTF8PROC_COMPOSE | UTF8PROC_STRIPCC)
	? ""

	# Decompose one codepoint
	aCodes = utf8proc_decompose_char(0x1E09, UTF8PROC_DECOMPOSE)
	? "U+1E09 decomposes to: " + unicodeToHex(unicodeFromCodepoints(aCodes))
	aCodes = utf8proc_decompose_char(0xFB01, UTF8PROC_DECOMPOSE | UTF8PROC_COMPAT)
	? "U+FB01 decomposes to: " + unicodeToHex(unicodeFromCodepoints(aCodes))
	? ""

	# Find the grapheme breaks using utf8proc_grapheme_break_stateful()
	cFlags = "🇪🇬🇯🇵"
	aCodes = unicodeCodepoints(cFlags)
	nState = 0
	nCount = len(aCodes)
	for x = 2 to nCount
		aResult = utf8proc_grapheme_break_stateful(aCodes[x-1], aCodes[x], nState)
		nState = aResult[2]
		? "Break between codepoint " + (x-1) + " and " + x + " : " + aResult[1]
	next
	? ""

	# Codepoint functions
	? "utf8proc_codepoint_valid(0xD800)    : " + utf8proc_codepoint_valid(0xD800)
	? "utf8proc_codepoint_valid(0x1F600)   : " + utf8proc_codepoint_valid(0x1F600)
	? "utf8proc_charwidth(0x4E00)          : " + utf8proc_charwidth(0x4E00)
	? "utf8proc_charwidth_ambiguous(0xB1)  : " + utf8proc_charwidth_ambiguous(0xB1)
	? "utf8proc_category_string(0x20AC)    : " + utf8proc_category_string(0x20AC)
	? "utf8proc_grapheme_break(0x61, 0x301): " + utf8proc_grapheme_break(0x61, 0x301)
