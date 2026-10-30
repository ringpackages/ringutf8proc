# Normalization forms (used with unicodeNormalize() and unicodeIsNormalized())
UNICODE_NFC = "NFC"
UNICODE_NFD = "NFD"
UNICODE_NFKC = "NFKC"
UNICODE_NFKD = "NFKD"
UNICODE_NFKC_CASEFOLD = "NFKC_CASEFOLD"

# The replacement character (U+FFFD) used by unicodeFixInvalid()
UNICODE_REPLACEMENTCHAR = 0xFFFD

# Separator used by unicodeSlug()
UNICODE_SLUGSEPARATOR = "-"

# Names of the bidirectional classes (index = class number, from UTF8PROC_BIDI_CLASS_L = 1)
UNICODE_BIDICLASSNAMES = ["L", "LRE", "LRO", "R", "AL", "RLE", "RLO", "PDF", "EN", "ES", "ET", "AN",
			  "CS", "NSM", "BN", "B", "S", "WS", "ON", "LRI", "RLI", "FSI", "PDI"]

# Arabic text: the Unicode blocks of the Arabic script ([nFirst, nLast] ranges)
UNICODE_ARABICRANGES = [
	[0x0600, 0x06FF],	# Arabic
	[0x0750, 0x077F],	# Arabic Supplement
	[0x0870, 0x089F],	# Arabic Extended-B
	[0x08A0, 0x08FF],	# Arabic Extended-A
	[0xFB50, 0xFDFF],	# Arabic Presentation Forms-A
	[0xFE70, 0xFEFF],	# Arabic Presentation Forms-B
	[0x10EC0, 0x10EFF],	# Arabic Extended-C
	[0x1EE00, 0x1EEFF]	# Arabic Mathematical Alphabetic Symbols
]

# Tatweel (Kashida), used to stretch words
UNICODE_ARABICTATWEEL = 0x0640

# Alef with Madda, Hamza above, Hamza below and Wasla (and other forms) become Alef
UNICODE_ARABICALEFPAIRS = [[0x0622, 0x0627], [0x0623, 0x0627], [0x0625, 0x0627],
			   [0x0671, 0x0627], [0x0672, 0x0627], [0x0673, 0x0627]]

# Extra replacements used by unicodeArabicSearchKey():
# Alef Maksura -> Yeh, Teh Marbuta -> Heh, Waw with Hamza -> Waw, Yeh with Hamza -> Yeh
UNICODE_ARABICSEARCHPAIRS = [[0x0649, 0x064A], [0x0629, 0x0647], [0x0624, 0x0648], [0x0626, 0x064A]]

# The first digit (zero) of the Arabic-Indic and the Extended Arabic-Indic (Persian/Urdu) digits
UNICODE_ARABICZERO = 0x0660
UNICODE_PERSIANZERO = 0x06F0

# Arabic presentation forms (used with unicodeArabicForm())
UNICODE_FORM_ISOLATED = RING_UTF8PROC_FORMISOLATED
UNICODE_FORM_FINAL = RING_UTF8PROC_FORMFINAL
UNICODE_FORM_INITIAL = RING_UTF8PROC_FORMINITIAL
UNICODE_FORM_MEDIAL = RING_UTF8PROC_FORMMEDIAL

# Arabic joining types (returned by unicodeArabicJoiningType())
UNICODE_JOIN_NONE = RING_UTF8PROC_JOINNONE
UNICODE_JOIN_RIGHT = RING_UTF8PROC_JOINRIGHT
UNICODE_JOIN_DUAL = RING_UTF8PROC_JOINDUAL
UNICODE_JOIN_CAUSING = RING_UTF8PROC_JOINCAUSING
UNICODE_JOIN_TRANSPARENT = RING_UTF8PROC_JOINTRANSPARENT

# Paragraph directions (used with unicodeBidiVisualDirection())
UNICODE_DIRECTION_AUTO = RING_UTF8PROC_DIRECTIONAUTO
UNICODE_DIRECTION_LTR = RING_UTF8PROC_DIRECTIONLTR
UNICODE_DIRECTION_RTL = RING_UTF8PROC_DIRECTIONRTL

# Tables built on the first use (by unicodeArabicTashkeelPairs() and unicodeArabicNormalizePairs())
aUnicodeArabicTashkeelPairs = []
aUnicodeArabicNormalizePairs = []

# The scripts of the letters, by Unicode blocks ([nFirst, nLast, cScript], used by unicodeScript())
UNICODE_SCRIPTRANGES = [
	[0x0041, 0x02AF, "Latin"], [0x0370, 0x03FF, "Greek"], [0x0400, 0x052F, "Cyrillic"],
	[0x0530, 0x058F, "Armenian"], [0x0590, 0x05FF, "Hebrew"], [0x0600, 0x06FF, "Arabic"],
	[0x0700, 0x074F, "Syriac"], [0x0750, 0x077F, "Arabic"], [0x0780, 0x07BF, "Thaana"],
	[0x0870, 0x08FF, "Arabic"], [0x0900, 0x097F, "Devanagari"], [0x0980, 0x09FF, "Bengali"],
	[0x0A00, 0x0A7F, "Gurmukhi"], [0x0A80, 0x0AFF, "Gujarati"], [0x0B80, 0x0BFF, "Tamil"],
	[0x0C00, 0x0C7F, "Telugu"], [0x0C80, 0x0CFF, "Kannada"], [0x0D00, 0x0D7F, "Malayalam"],
	[0x0E00, 0x0E7F, "Thai"], [0x0E80, 0x0EFF, "Lao"], [0x0F00, 0x0FFF, "Tibetan"],
	[0x10A0, 0x10FF, "Georgian"], [0x1100, 0x11FF, "Hangul"], [0x1200, 0x139F, "Ethiopic"],
	[0x1E00, 0x1EFF, "Latin"], [0x1F00, 0x1FFF, "Greek"], [0x2C60, 0x2C7F, "Latin"],
	[0x2D80, 0x2DDF, "Ethiopic"], [0x3040, 0x309F, "Hiragana"], [0x30A0, 0x30FF, "Katakana"],
	[0x3130, 0x318F, "Hangul"], [0x31F0, 0x31FF, "Katakana"], [0x3400, 0x4DBF, "Han"],
	[0x4E00, 0x9FFF, "Han"], [0xA720, 0xA7FF, "Latin"], [0xAC00, 0xD7AF, "Hangul"],
	[0xF900, 0xFAFF, "Han"], [0xFB00, 0xFB06, "Latin"], [0xFB1D, 0xFB4F, "Hebrew"],
	[0xFB50, 0xFDFF, "Arabic"], [0xFE70, 0xFEFF, "Arabic"], [0xFF21, 0xFF3A, "Latin"],
	[0xFF41, 0xFF5A, "Latin"], [0xFF66, 0xFF9F, "Katakana"], [0xFFA0, 0xFFDC, "Hangul"],
	[0x10EC0, 0x10EFF, "Arabic"], [0x1EE00, 0x1EEFF, "Arabic"], [0x20000, 0x323AF, "Han"]
]

# The script of characters that are not letters, marks or digits of a script (like spaces, punctuation and ASCII digits)
UNICODE_SCRIPTCOMMON = "Common"

# The script of letters that are not in UNICODE_SCRIPTRANGES
UNICODE_SCRIPTOTHER = "Other"

# Prefix of the errors raised by the library
UNICODE_ERRORPREFIX = "utf8proc Error: "

# Names of the Unicode general categories (index = category number + 1)
UNICODE_CATEGORYNAMES = [
	"Other, not assigned",
	"Letter, uppercase",
	"Letter, lowercase",
	"Letter, titlecase",
	"Letter, modifier",
	"Letter, other",
	"Mark, nonspacing",
	"Mark, spacing combining",
	"Mark, enclosing",
	"Number, decimal digit",
	"Number, letter",
	"Number, other",
	"Punctuation, connector",
	"Punctuation, dash",
	"Punctuation, open",
	"Punctuation, close",
	"Punctuation, initial quote",
	"Punctuation, final quote",
	"Punctuation, other",
	"Symbol, math",
	"Symbol, currency",
	"Symbol, modifier",
	"Symbol, other",
	"Separator, space",
	"Separator, line",
	"Separator, paragraph",
	"Other, control",
	"Other, format",
	"Other, surrogate",
	"Other, private use"
]
