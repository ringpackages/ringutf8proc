# RingUTF8Proc Package

## Overview

RingUTF8Proc package for the Ring programming language

RingUTF8Proc brings Unicode text processing to Ring using the utf8proc library (version 2.12.0, Unicode 18.0.0). Use it to normalize strings, convert the case of any script, compare strings ignoring case and accents, split text into user-perceived characters (grapheme clusters), measure the display width of text in terminals, and read the Unicode properties of characters.

The package has two layers:

1. **C Extension** (`ring/extensions/ringutf8proc`): `utf8proc.cf` is processed by the Ring code generator to produce `ring_utf8proc.c`, which wraps the utf8proc API. The utf8proc source code is bundled in the `utf8proc` folder and compiled with the extension, so there are no external dependencies.
2. **Ring Library** (`ring/libraries/utf8proclib`): the `unicode*()` functions and the `UnicodeString` class.

## Features

- Normalization forms NFC, NFD, NFKC, NFKD and NFKC_Casefold
- Upper, lower and title case for all the scripts that have letter case (Latin, Greek, Cyrillic, Armenian, ...)
- Case folding and case-insensitive comparison
- Canonical comparison (`"é"` as one codepoint equals `"e"` + combining accent)
- Grapheme clusters (UAX #29): emoji ZWJ sequences, flags, skin tones, combining marks and Indic scripts count as one character
- Grapheme-aware length, reverse and substrings
- Display width for aligning tables that contain East Asian characters and emoji
- Character properties: category, bidi class, combining class, width and more
- Text cleanup: remove accents and diacritics (including Arabic Tashkeel), control characters and ignorable characters, lump similar punctuation, create URL slugs
- Words, and line wrapping by display width (including East Asian text without spaces)
- Sorting, comparing and searching that ignore case, accents and width differences
- Trim of all the Unicode white space, and find and replace by whole characters (safe for strings that contain `char(0)`)
- Arabic text: remove Tashkeel and Tatweel, unify the Alef forms, normalize presentation forms and ligatures, search and sort ignoring these differences
- Digits of all the scripts: convert between ASCII, Arabic-Indic and Persian digits, and get the value of any decimal digit
- Arabic shaping (presentation forms and Lam-Alef ligatures, also for Persian and Urdu letters) and bidirectional visual order, for Windows Terminal, game engines (RayLib, SDL, Allegro) and simple PDF writers
- UTF-8 validation and replacing invalid bytes with U+FFFD
- Fast: the loops over characters run in C (200,000 characters are measured or wrapped in a few milliseconds)
- Tested on Windows (x64) and Linux (x64) with the same results, with unit tests and a fuzz test
- Binary safe: strings may contain `char(0)`
- Direct access to the utf8proc functions and options

## Installation

	ringpm install ringutf8proc from ringpackages

## Quick Start

```ring
load "utf8proclib.ring"

func main
	unicodeSetupConsole()           # Use UTF-8 in the Windows console

	# Normalization and comparison
	? unicodeEqual("Café", "Cafe" + unicodeChar(0x301))   # 1
	? unicodeEqualIgnoreCase("STRASSE", "straße")          # 1

	# Case mapping
	? unicodeUpper("élan vital")                           # ÉLAN VITAL
	? unicodeTitle("москва")                               # Москва

	# Grapheme clusters
	cText = "👨‍👩‍👧🇪🇬é"
	? len(cText)                                           # 28 bytes
	? unicodeLength(cText)                                 # 8 codepoints
	? unicodeGraphemeCount(cText)                          # 3 characters
	? unicodeReverse("abc🇪🇬")                              # 🇪🇬cba

	# Display width
	? unicodePadRight("日本語", 10) + "|"                   # 日本語    |

	# Text cleanup
	? unicodeStripMarks("Crème Brûlée")                    # Creme Brulee
	? unicodeSlug("Crème Brûlée — Recipe #1")              # creme-brulee-recipe-1

	# The UnicodeString class
	oText = new UnicodeString("Crème Brûlée")
	? oText.stripMarks().toUpper().value()                 # CREME BRULEE
```

Put the program code inside `func main` (as in the samples): the library functions use local variables such as `x` and `nCount`, and in Ring a function that assigns to a name that exists as a global variable changes the global variable.

---

## API Reference

Functions that process strings raise a Ring error that starts with `utf8proc Error: ` when the string is not valid UTF-8 (use `unicodeIsValid()` or `unicodeFixInvalid()` first for untrusted input). The character functions accept a codepoint number or a one character string.

### Information

| Function | Description |
|----------|-------------|
| `unicodeVersion()` | Unicode version (`"18.0.0"`) |
| `unicodeLibVersion()` | utf8proc version (`"2.12.0"`) |
| `unicodeSetupConsole()` | Switch the Windows console to UTF-8 (code page 65001); does nothing on other systems |

### Validation

| Function | Description |
|----------|-------------|
| `unicodeIsValid(cStr)` | True if the string is valid UTF-8 |
| `unicodeFixInvalid(cStr)` | Replace each invalid byte with U+FFFD |

### Normalization

| Function | Description |
|----------|-------------|
| `unicodeNFC(cStr)` | Canonical composition (the usual form for storing text) |
| `unicodeNFD(cStr)` | Canonical decomposition |
| `unicodeNFKC(cStr)` | Compatibility composition (`"ﬁ"` → `"fi"`, `"①"` → `"1"`, full width → ASCII) |
| `unicodeNFKD(cStr)` | Compatibility decomposition |
| `unicodeNFKCCaseFold(cStr)` | NFKC + case folding + removing ignorable characters (for identifiers and search keys) |
| `unicodeNormalize(cStr, cForm)` | Normalize using `UNICODE_NFC`, `UNICODE_NFD`, `UNICODE_NFKC`, `UNICODE_NFKD` or `UNICODE_NFKC_CASEFOLD` |
| `unicodeIsNormalized(cStr, cForm)` | True if the string is already in the form |

### Case Mapping and Comparison

| Function | Description |
|----------|-------------|
| `unicodeUpper(cStr)` | Upper case (one codepoint to one codepoint, so `"ß"` becomes `"ẞ"`) |
| `unicodeLower(cStr)` | Lower case |
| `unicodeTitle(cStr)` | First letter of each word in title case, the other letters in lower case |
| `unicodeCaseFold(cStr)` | Case folding for comparisons (`"Straße"` → `"strasse"`) |
| `unicodeEqual(cStr1, cStr2)` | True if the strings are equal after NFC |
| `unicodeEqualIgnoreCase(cStr1, cStr2)` | True if the strings are equal after NFKC_Casefold |

### Text Cleanup

| Function | Description |
|----------|-------------|
| `unicodeStripMarks(cStr)` | Remove accents and other marks (`"naïve"` → `"naive"`, Arabic Tashkeel) |
| `unicodeStripControls(cStr)` | Remove control characters; new lines and tabs become spaces |
| `unicodeRemoveIgnorable(cStr)` | Remove default ignorable characters (soft hyphen, zero width space, ...) |
| `unicodeLump(cStr)` | Replace similar characters by ASCII (dashes → `-`, single quotes → `'`, ...) |
| `unicodeSlug(cStr)` | Lower case words without marks joined by `-` (apostrophes are removed: `Don't` → `dont`) |

### Trim, Find and Replace

These functions work on whole user-perceived characters, so `"e"` is not found inside `"e"` + combining accent, and `"👩"` is not found inside the family emoji `"👨‍👩‍👧"`. They are safe for strings that contain `char(0)`.

| Function | Description |
|----------|-------------|
| `unicodeTrim(cStr)` | Remove white space from both ends: all the space separators (like U+3000 and U+00A0), tabs and line breaks (Ring `trim()` removes ASCII spaces only) |
| `unicodeTrimLeft(cStr)`, `unicodeTrimRight(cStr)` | Remove white space from the start or from the end |
| `unicodeFind(cStr, cSubStr)` | Position of the first match counted in characters (from 1), or 0 |
| `unicodeReplace(cStr, cOld, cNew)` | Replace all the matches |

### Arabic Text

Arabic text can be written in different ways that readers consider the same: with or without Tashkeel (diacritics), stretched with Tatweel, using different Alef forms, or stored as presentation forms (shaped letters) by old software. These functions remove the differences.

| Function | Description |
|----------|-------------|
| `unicodeArabicStripTashkeel(cStr)` | Remove the Arabic diacritics and Quranic marks (`"الْعِلْمُ"` → `"العلم"`); keeps the Hamza and Madda letters (`أ`, `إ`, `آ`) and the marks of other scripts |
| `unicodeArabicHasTashkeel(cStr)` | True if the text contains Tashkeel |
| `unicodeArabicRemoveTatweel(cStr)` | Remove Tatweel (`"كتـــاب"` → `"كتاب"`) |
| `unicodeArabicNormalizeAlef(cStr)` | `أ`, `إ`, `آ`, `ٱ` become `ا` |
| `unicodeArabicNormalize(cStr)` | NFKC (presentation forms and ligatures like `ﻻ` and `ﷲ` become letters), remove Tashkeel and Tatweel, unify the Alef forms |
| `unicodeArabicSearchKey(cStr)` | `unicodeArabicNormalize()`, then `ى` → `ي`, `ة` → `ه`, `ؤ` → `و`, `ئ` → `ي`, digits → ASCII, and `unicodeSearchKey()` |
| `unicodeArabicSearch(cStr, cQuery)` | True if the query is found, ignoring all these differences (`"المَدْرَسَةِ"` matches `"المدرسه"`) |
| `unicodeArabicCompare(cStr1, cStr2)` | `-1`, `0` or `1` using the Arabic search keys |
| `unicodeArabicSort(aList)` | A sorted copy in the order of the Arabic alphabet (Hamza forms, Tashkeel and presentation forms don't change the order) |
| `unicodeIsArabic(vChar)` | True for the characters of the Arabic Unicode blocks |
| `unicodeHasArabic(cStr)`, `unicodeArabicCharCount(cStr)` | Find and count the Arabic codepoints |
| `unicodeArabicTashkeelPairs()` | The table used to remove Tashkeel (built from the Unicode data: the nonspacing marks of the Arabic blocks) |

Terminals that support bidirectional text (like GNOME Terminal and Konsole) show Arabic right to left. Windows Terminal joins the letters but shows them left to right, so text printed in logical order looks reversed there: use `unicodeArabicVisual()` (see the next section) to print it. The library keeps text in logical order (the order of reading), which is the order to store and process text.

### Arabic Shaping and Visual Order

Text is stored and processed in logical order (the order of reading). Some renderers draw each codepoint alone from left to right: Windows Terminal (it joins the letters but doesn't reorder right-to-left text), game engines (RayLib `DrawTextEx()`, SDL_ttf, Allegro) and simple PDF writers. For them, the letters must be shaped (each letter replaced by the presentation form that connects it to its neighbors) and the text put in visual order.

| Function | Description |
|----------|-------------|
| `unicodeArabicVisual(cStr)` | Shape, then reorder: ready to print in Windows Terminal or to draw using a game engine |
| `unicodeArabicVisualWrap(cStr, nWidth)` | Wrap in logical order, then shape and reorder each line (draw the lines from top to bottom, aligned to the right) |
| `unicodeArabicShape(cStr)` | Presentation forms (isolated, initial, medial, final) and Lam-Alef ligatures, without reordering (for renderers that reorder but don't shape) |
| `unicodeBidiVisual(cStr)` | Reorder each line to visual order; the direction of a line comes from its first strong character |
| `unicodeBidiVisualDirection(cStr, nDirection)` | Reorder using `UNICODE_DIRECTION_AUTO`, `UNICODE_DIRECTION_LTR` or `UNICODE_DIRECTION_RTL` |
| `unicodeArabicJoiningType(vChar)` | `UNICODE_JOIN_NONE`, `UNICODE_JOIN_RIGHT` (like Alef), `UNICODE_JOIN_DUAL` (like Beh), `UNICODE_JOIN_CAUSING` (Tatweel, ZWJ) or `UNICODE_JOIN_TRANSPARENT` (Tashkeel) |
| `unicodeArabicForm(vChar, nForm)` | The presentation form (`UNICODE_FORM_ISOLATED`, `UNICODE_FORM_FINAL`, `UNICODE_FORM_INITIAL`, `UNICODE_FORM_MEDIAL`), or 0 |
| `unicodeSetupVisualConsole()` | Before printing visual order: UTF-8 on Windows; on other systems `ESC[8l` asks terminals that reorder right-to-left text (like VTE) to keep the visual order |

The visual order uses the rules of the Unicode Bidirectional Algorithm (UAX 9) for numbers, separators, neutrals and mirrored brackets, so `"السعر 120 ريال"` and `"Ring لغة 2026"` are ordered like in browsers. A letter stays before its Tashkeel, and emoji sequences stay together. The explicit embedding and isolate characters (LRE, RLI, ...) are not supported.

The presentation forms table is built from the Unicode data (the `<isolated>`, `<final>`, `<initial>` and `<medial>` decompositions), so the Persian and Urdu letters (`پ چ ژ گ ک ی`) are shaped too.

### Digits

| Function | Description |
|----------|-------------|
| `unicodeAsciiDigits(cStr)` | Decimal digits of all the scripts → `0123456789` (`"٢٠٢٦"` → `"2026"`) |
| `unicodeArabicDigits(cStr)` | Digits → Arabic-Indic digits `٠١٢٣٤٥٦٧٨٩` |
| `unicodePersianDigits(cStr)` | Digits → Extended Arabic-Indic digits `۰۱۲۳۴۵۶۷۸۹` (Persian and Urdu) |
| `unicodeDigitValue(vChar)` | Value of a decimal digit of any script, or -1 |

### Character Mapping

| Function | Description |
|----------|-------------|
| `unicodeMapChars(cStr, aPairs)` | Replace characters using `[nFrom, vTo]` pairs: `vTo` is a codepoint, `-1` (remove) or a string |
| `unicodeCountInRanges(cStr, aRanges)` | Number of codepoints inside the `[nFirst, nLast]` ranges |

### Words and Lines

| Function | Description |
|----------|-------------|
| `unicodeWords(cStr)` | List of words (letters, marks and numbers; `don't` and `l'été` are one word) |
| `unicodeWordCount(cStr)` | Number of words |
| `unicodeWrap(cStr, nWidth)` | List of lines of at most `nWidth` columns (breaks at spaces and between East Asian characters, keeps closing punctuation like `。` on the line, splits longer words) |
| `unicodeWrapText(cStr, nWidth)` | The wrapped lines joined with `nl` |

### Search and Sorting

These functions ignore case, accents and width differences (`"Ｃａｆé"` matches `"cafe"`).

| Function | Description |
|----------|-------------|
| `unicodeSearchKey(cStr)` | The key used for comparisons: NFKC, case folded, without marks and ignorable characters |
| `unicodeSearch(cStr, cQuery)` | True if `cQuery` is found in `cStr` |
| `unicodeCompare(cStr1, cStr2)` | `-1`, `0` or `1` |
| `unicodeSort(aList)` | A sorted copy of a list of strings (`banana, Cherry, éclair, zebra`) |

### Length and Display Width

| Function | Description |
|----------|-------------|
| `unicodeLength(cStr)` | Number of codepoints |
| `unicodeGraphemeCount(cStr)` | Number of user-perceived characters |
| `unicodeWidth(cStr)` | Terminal columns (wide characters and emoji use 2 columns, marks use 0) |
| `unicodeGraphemeWidth(cGrapheme)` | Columns of one grapheme cluster |
| `unicodeTruncate(cStr, nWidth)` | Leading characters that fit in `nWidth` columns |
| `unicodePadRight(cStr, nWidth)`, `unicodePadLeft(cStr, nWidth)`, `unicodeCenter(cStr, nWidth)` | Add spaces to reach `nWidth` columns |

### Grapheme Clusters

| Function | Description |
|----------|-------------|
| `unicodeGraphemes(cStr)` | List of the grapheme clusters |
| `unicodeSubStr(cStr, nStart, nCount)` | `nCount` characters starting from character `nStart` |
| `unicodeLeft(cStr, nCount)`, `unicodeRight(cStr, nCount)` | First or last characters |
| `unicodeReverse(cStr)` | Reverse the characters (keeps emoji and accents intact) |

### Codepoints

| Function | Description |
|----------|-------------|
| `unicodeCodepoints(cStr)` | List of codepoints |
| `unicodeFromCodepoints(aCodes)` | String of a list of codepoints |
| `unicodeChar(nCode)` | String of one codepoint |
| `unicodeCode(cChar)` | Codepoint of the first character |
| `unicodeToHex(cStr)` | Codepoints as text (`"U+0041 U+00E9"`) |
| `unicodeToHexBytes(cStr)` | The UTF-8 bytes in hexadecimal (`"E2 82 AC"`) |
| `unicodeInfo(cStr)` | A description: sizes, then each character with its codepoints, category, script, width and bytes (`? unicodeInfo(cStr)`) |

### Character Properties

| Function | Description |
|----------|-------------|
| `unicodeCharInfo(vChar)` | List of `[key, value]` pairs (category, bidiclass, combiningclass, charwidth, lowercase, uppercase, ...) |
| `unicodeCategory(vChar)` | Two letter category (`"Lu"`, `"Nd"`, ...) |
| `unicodeCategoryName(vChar)` | Category name (`"Letter, uppercase"`) |
| `unicodeCharWidth(vChar)` | Display width of a codepoint |
| `unicodeIsLetter(vChar)`, `unicodeIsMark(vChar)`, `unicodeIsDigit(vChar)`, `unicodeIsNumber(vChar)` | Category tests |
| `unicodeIsPunct(vChar)`, `unicodeIsSymbol(vChar)`, `unicodeIsSpace(vChar)`, `unicodeIsControl(vChar)` | Category tests |
| `unicodeIsUpper(vChar)`, `unicodeIsLower(vChar)` | Case tests |
| `unicodeBidiClass(vChar)` | Bidirectional class name: `"L"`, `"R"`, `"AL"` (Arabic letter), `"AN"` (Arabic number), `"NSM"` (mark), ... |
| `unicodeIsRTL(vChar)` | True for right-to-left characters (bidi class `R` or `AL`) |
| `unicodeScript(vChar)` | The script of a letter, mark or digit by Unicode blocks (`"Latin"`, `"Arabic"`, `"Han"`, `"Cyrillic"`, ...); `"Common"` for spaces, punctuation, symbols and ASCII digits |
| `unicodeIsCJK(vChar)` | True for the CJK ideographs (Han) |
| `unicodeIsWide(vChar)` | True for characters that use two columns |

---

### UnicodeString Class

Create it using `new UnicodeString(cText)` (or `new UnicodeString` for an empty string; `new UnicodeString()` with empty parentheses raises an error because `init()` expects the text). The transformation methods change the text and return the object, so calls can be chained.

| Method | Description |
|--------|-------------|
| `setValue(cText)`, `value()` | Set or get the text |
| `byteCount()`, `codepointCount()`, `graphemeCount()`, `width()` | Sizes |
| `isValid()`, `isEmpty()`, `isNormalized(cForm)` | Tests |
| `equals(cOther)`, `equalsIgnoreCase(cOther)` | Comparison |
| `graphemes()`, `codepoints()`, `graphemeAt(nIndex)`, `subString(nStart, nCount)`, `toHex()` | Parts |
| `words()`, `wordCount()`, `wrap(nWidth)` | Words and lines |
| `contains(cQuery)`, `compare(cOther)` | Search and comparison ignoring case, accents and width |
| `findText(cSubStr)` | Position of the first match in characters, or 0 |
| `trimSpaces()`, `replaceText(cOld, cNew)` | Trim and replace (return self) |
| `hasArabic()`, `info()` | True if the text contains Arabic; the description from `unicodeInfo()` |
| `arabicNormalize()`, `arabicStripTashkeel()`, `toArabicDigits()`, `toAsciiDigits()` | Arabic text and digits (return self) |
| `arabicShape()`, `arabicVisual()`, `bidiVisual()` | Shaping and visual order (return self) |
| `toNFC()`, `toNFD()`, `toNFKC()`, `toNFKD()` | Normalization (return self) |
| `toUpper()`, `toLower()`, `toTitle()`, `toCaseFold()` | Case (return self) |
| `toReversed()`, `toSlug()`, `stripMarks()`, `stripControls()`, `fixInvalid()` | Transformations (return self) |
| `truncate(nWidth)`, `padRight(nWidth)`, `padLeft(nWidth)`, `center(nWidth)` | Display width (return self) |

---

### Extension Functions

The utf8proc functions (`utf8proc_map()`, `utf8proc_NFC()`, `utf8proc_get_property()`, `utf8proc_grapheme_break_stateful()`, ...) and constants (`UTF8PROC_COMPOSE`, `UTF8PROC_CASEFOLD`, `UTF8PROC_CATEGORY_LU`, ...) can be used directly. See `ring/extensions/ringutf8proc/README.md`.

## Samples

See the folder `ring/samples/UsingUTF8Proc`:

| Sample | Description |
|--------|-------------|
| `test01_library_info.ring` | Versions |
| `test02_normalization.ring` | NFC, NFD, NFKC and NFKD |
| `test03_case_mapping.ring` | Case mapping for many scripts |
| `test04_compare_strings.ring` | Exact, canonical and case-insensitive comparison |
| `test05_codepoints.ring` | Codepoints and `utf8proc_iterate()` |
| `test06_graphemes.ring` | Grapheme clusters, reverse and substrings |
| `test07_display_width.ring` | Aligned tables with wide characters and emoji |
| `test08_char_properties.ring` | Character properties and classification |
| `test09_validation.ring` | Invalid UTF-8 and errors |
| `test10_text_cleanup.ring` | Strip marks, lump, controls and slugs |
| `test11_arabic_text.ring` | Arabic Tashkeel, presentation forms and digits |
| `test12_unicodestring_class.ring` | The `UnicodeString` class |
| `test13_low_level_api.ring` | utf8proc options, decomposition and grapheme breaks |
| `test14_search.ring` | Search that ignores case, accents and width |
| `test15_unit_tests.ring` | Unit tests |
| `test16_words_and_wrap.ring` | Words and line wrapping |
| `test17_sort_and_search.ring` | Sorting, comparing and searching |
| `test18_trim_find_replace.ring` | Trim, find and replace by characters |
| `test19_fuzz_test.ring` | Fuzz test with random text (including Arabic) and invalid UTF-8 (expected result: `Problems: 0`) |
| `test20_arabic_tashkeel.ring` | Arabic Tashkeel: count, show and remove |
| `test21_arabic_normalization.ring` | Alef forms, Tatweel, presentation forms, ligatures and search keys |
| `test22_arabic_search.ring` | Searching Arabic book titles ignoring Tashkeel, Hamza forms and digit forms |
| `test23_arabic_sort.ring` | Sorting Arabic words in the order of the alphabet |
| `test24_arabic_digits.ring` | Arabic-Indic and Persian digits, and calculations with them |
| `test25_arabic_words_wrap.ring` | Arabic words, word frequency, wrapping and truncating |
| `test26_arabic_properties.ring` | Categories, bidi classes and widths of Arabic characters |
| `test27_arabic_unit_tests.ring` | Unit tests for Arabic text |
| `test28_arabic_shaping.ring` | The presentation forms table and shaping words (Arabic and Persian) |
| `test29_bidi_visual.ring` | Logical and visual order of mixed text, numbers, brackets and lines |
| `test30_arabic_terminal.ring` | Printing Arabic in Windows Terminal: a right aligned paragraph and a table |
| `test31_from_utf8lib.ring` | The UTF8Lib functions and the functions that replace them |
| `test32_shaping_bidi_unit_tests.ring` | Unit tests for shaping, visual order, scripts and utilities |

## Moving from UTF8Lib

The functions of UTF8Lib (`ringutf8.ring`) and the functions of this package that do the same work:

| UTF8Lib | UTF8ProcLib |
|---------|-------------|
| `utf8Decode()`, `utf8Encode()`, `utf8Char()` | `unicodeCodepoints()`, `unicodeFromCodepoints()`, `unicodeChar()` |
| `utf8Len()`, `utf8Sub()`, `utf8Reverse()` | `unicodeLength()` (codepoints) or `unicodeGraphemeCount()` (characters), `unicodeSubStr()`, `unicodeReverse()` |
| `utf8Code(text, pos)`, `utf8Bytes(cp)` | `unicodeCodepoints(cStr)[nPos]`, `len(unicodeChar(nCode))` |
| `utf8Valid()` | `unicodeIsValid()` |
| `utf8IsArabic()`, `utf8IsArabicLetter()`, `utf8IsArabicDiacritic()`, `utf8IsArabicDigit()` | `unicodeIsArabic()` with `unicodeIsLetter()`, `unicodeIsMark()` or `unicodeIsDigit()` |
| `utf8IsLatin()`, `utf8IsCJK()` | `unicodeScript() = "Latin"`, `unicodeIsCJK()` |
| `utf8IsDigit()`, `utf8IsSpace()`, `utf8IsRTL()` | `unicodeIsDigit()`, `unicodeIsSpace()`, `unicodeIsRTL()` (all the scripts) |
| `arabicGetForm()`, `arabicGetJoinType()` | `unicodeArabicForm()`, `unicodeArabicJoiningType()` |
| `arabicShape()`, `arabicShapeOnly()` | `unicodeArabicShape()` |
| `bidiReorder()` | `unicodeBidiVisual()` |
| `arabicProcess()`, `arabicShapeForGame()` | `unicodeArabicVisual()` |
| `arabicReverse()` | `unicodeReverse()` (keeps the Tashkeel after the letters) |
| `utf8ToHex()`, `utf8CodepointsToHex()`, `utf8PrintInfo()` | `unicodeToHexBytes()`, `unicodeToHex()`, `? unicodeInfo()` |

## License

MIT License.