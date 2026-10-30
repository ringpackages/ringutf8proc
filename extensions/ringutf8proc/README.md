# RingUTF8Proc Extension

## Introduction

This extension wraps the utf8proc library (version 2.12.0, Unicode 18.0.0) for Ring.

utf8proc URL: https://github.com/JuliaStrings/utf8proc

The utf8proc source code is bundled in the `utf8proc` folder and compiled into the extension (with `UTF8PROC_STATIC` defined), so there are no external dependencies.

The functions and constants of this extension are loaded with the RingUTF8Proc package, together with the high-level functions and the `UnicodeString` class from `ring/libraries/utf8proclib`:

```ring
load "utf8proclib.ring"

? utf8proc_NFC("e" + utf8proc_encode_char(0x301))
? utf8proc_map("Ｈéllo", UTF8PROC_COMPOSE | UTF8PROC_COMPAT | UTF8PROC_CASEFOLD)
? utf8proc_graphemes("🇪🇬👨‍👩‍👧")
```

## Files

| File | Description |
|------|-------------|
| `utf8proc.cf` | Configuration file for the Ring code generator |
| `ring_utf8proc.c` | Generated C source code |
| `ring_utf8proc.rh` | Generated constants |
| `utf8proc.ring` | Loads the extension library and the constants |
| `gencode.bat`, `gencode.sh` | Generate `ring_utf8proc.c` and `ring_utf8proc.rh` from `utf8proc.cf` |
| `buildvc.bat`, `buildvc_x64.bat` | Build using Visual C/C++ (32-bit and 64-bit) |
| `buildgcc.sh` | Build using GCC (Linux) |
| `buildclang.sh` | Build using Clang (macOS) |
| `utf8proc` | utf8proc source code (`utf8proc.c`, `utf8proc.h`, `utf8proc_data.c`) and license |

## Building

Run the scripts from this folder (inside the Ring folder):

	gencode.bat
	buildvc_x64.bat

On Linux and macOS:

	./gencode.sh
	./buildgcc.sh      (or ./buildclang.sh)

The library is written to `ring/bin/ring_utf8proc.dll`, `ring/lib/libring_utf8proc.so` or `ring/lib/libring_utf8proc.dylib`.

## Functions

Strings are processed using their length, so they may contain `char(0)`.
Functions that process strings raise a Ring error that starts with `utf8proc Error: ` for invalid UTF-8 or invalid options.

### Wrapped utf8proc functions

The codepoint parameters are checked: a number outside the range 0 to 0x10FFFF raises an error (`utf8proc_codepoint_valid()` returns false instead).

| Function | Description |
|----------|-------------|
| `utf8proc_version()` | utf8proc version string |
| `utf8proc_unicode_version()` | Unicode version string |
| `utf8proc_errmsg(nError)` | Message of a `UTF8PROC_ERROR_*` code |
| `utf8proc_codepoint_valid(nCode)` | True for valid codepoints (not surrogates, not above U+10FFFF) |
| `utf8proc_tolower(nCode)`, `utf8proc_toupper(nCode)`, `utf8proc_totitle(nCode)` | Case mapping of one codepoint |
| `utf8proc_islower(nCode)`, `utf8proc_isupper(nCode)` | Case of one codepoint |
| `utf8proc_charwidth(nCode)` | Display width (0, 1 or 2) |
| `utf8proc_charwidth_ambiguous(nCode)` | True for East Asian Ambiguous width |
| `utf8proc_category(nCode)` | Category number (`UTF8PROC_CATEGORY_*`) |
| `utf8proc_category_string(nCode)` | Two letter category (`"Lu"`, `"Nd"`, ...) |
| `utf8proc_grapheme_break(nCode1, nCode2)` | True if a grapheme break is allowed between the codepoints (without state) |

### Functions adapted for Ring

| Function | Description |
|----------|-------------|
| `utf8proc_map(cStr, nOptions)` | Map a string using a combination of the `UTF8PROC_*` options |
| `utf8proc_NFC(cStr)`, `utf8proc_NFD(cStr)`, `utf8proc_NFKC(cStr)`, `utf8proc_NFKD(cStr)` | Normalization forms |
| `utf8proc_NFKC_Casefold(cStr)` | NFKC + case folding + removing default ignorable characters |
| `utf8proc_encode_char(nCode)` | UTF-8 string of a codepoint |
| `utf8proc_iterate(cStr, nPos)` | Read the codepoint at byte `nPos` (1-based); returns `[nCode, nBytes]` (`nBytes` is 0 at the end, negative for invalid UTF-8) |
| `utf8proc_get_property(nCode)` | List of `[key, value]` pairs: `codepoint`, `category`, `categorystring`, `combiningclass`, `bidiclass`, `decomptype`, `bidimirrored`, `compexclusion`, `ignorable`, `controlboundary`, `charwidth`, `ambiguouswidth`, `boundclass`, `indicconjunctbreak`, `lowercase`, `uppercase`, `titlecase` |
| `utf8proc_decompose_char(nCode, nOptions)` | List of codepoints of the decomposition |
| `utf8proc_grapheme_break_stateful(nCode1, nCode2, nState)` | Returns `[lBreak, nNewState]`; start with state 0 |

### Extra functions

| Function | Description |
|----------|-------------|
| `utf8proc_isvalid(cStr)` | True if the string is valid UTF-8 |
| `utf8proc_length(cStr)` | Number of codepoints |
| `utf8proc_strwidth(cStr)` | Sum of the display widths of the codepoints |
| `utf8proc_displaywidth(cStr)` | Display width measured by grapheme clusters: an emoji sequence or a flag uses 2 columns, a combining mark 0 |
| `utf8proc_truncatewidth(cStr, nWidth)` | The leading grapheme clusters that fit in `nWidth` columns |
| `utf8proc_wrap(cStr, nWidth)` | List of lines of at most `nWidth` columns: breaks at spaces, between wide (East Asian) characters and at line breaks; a line doesn't start with closing punctuation or end with an opening bracket next to wide characters; longer words are split |
| `utf8proc_words(cStr)` | List of words (letters, marks and numbers; an apostrophe between letters is kept, like `don't`) |
| `utf8proc_replaceinvalid(cStr)` | Replace each byte that is not part of valid UTF-8 with U+FFFD |
| `utf8proc_trim(cStr)`, `utf8proc_trimleft(cStr)`, `utf8proc_trimright(cStr)` | Remove Unicode white space (space separators like U+3000 and U+00A0, line and paragraph separators, tab, LF, VT, FF, CR, NEL) as whole grapheme clusters |
| `utf8proc_find(cStr, cSubStr)` | Position of the first match counted in grapheme clusters (from 1), or 0; a match starts and ends at cluster boundaries |
| `utf8proc_replace(cStr, cOld, cNew)` | Replace all the matches of `cOld` that start and end at cluster boundaries; safe for strings that contain `char(0)` |
| `utf8proc_mapchars(cStr, aPairs)` | Replace characters using a list of `[nFrom, vTo]` pairs: `vTo` is a codepoint, `-1` (remove the character) or a string; the first pair wins when a codepoint is repeated |
| `utf8proc_digitvalue(nCode)` | Value (0 to 9) of a decimal digit of any script (Arabic-Indic, Persian, Devanagari, full width, ...), or -1 |
| `utf8proc_asciidigits(cStr)` | Replace the decimal digits of all the scripts with the ASCII digits |
| `utf8proc_countranges(cStr, aRanges)` | Number of codepoints inside any of the `[nFirst, nLast]` ranges |
| `utf8proc_arabicshape(cStr)` | Replace the Arabic letters with their presentation forms (isolated, initial, medial, final) and the Lam-Alef ligatures; the forms table is built from the Unicode decomposition data, so Persian and Urdu letters are shaped too |
| `utf8proc_arabicjoiningtype(nCode)` | `RING_UTF8PROC_JOINNONE`, `JOINRIGHT`, `JOINDUAL`, `JOINCAUSING` (Tatweel, ZWJ) or `JOINTRANSPARENT` (marks) |
| `utf8proc_arabicform(nCode, nForm)` | The presentation form (`RING_UTF8PROC_FORMISOLATED`, `FORMFINAL`, `FORMINITIAL`, `FORMMEDIAL`) of a letter, or 0 |
| `utf8proc_bidivisual(cStr, nDirection)` | Reorder each line from logical to visual order (`RING_UTF8PROC_DIRECTIONAUTO`, `DIRECTIONLTR`, `DIRECTIONRTL`) using the rules W1-W7, N1, N2, I1, I2, L1, L2 and L4 of the Unicode Bidirectional Algorithm (UAX 9); grapheme clusters stay together and brackets are mirrored; explicit embeddings and isolates are not supported |
| `utf8proc_codepoints(cStr)` | List of codepoints |
| `utf8proc_fromcodepoints(aCodes)` | UTF-8 string of a list of codepoints |
| `utf8proc_graphemes(cStr)` | List of grapheme clusters (UAX #29) |
| `utf8proc_graphemecount(cStr)` | Number of grapheme clusters |
| `utf8proc_lowerstring(cStr)`, `utf8proc_upperstring(cStr)` | Case conversion of a string (one codepoint to one codepoint) |
| `utf8proc_titlestring(cStr)` | Title case: first letter of each word in title case, the other letters in lower case (`o'neil` becomes `O'neil`, `'hello'` becomes `'Hello'`) |

## Testing

- `samples/UsingUTF8Proc/test15_unit_tests.ring`: unit tests
- `samples/UsingUTF8Proc/test27_arabic_unit_tests.ring`: unit tests for Arabic text
- `samples/UsingUTF8Proc/test32_shaping_bidi_unit_tests.ring`: unit tests for shaping and visual order
- `samples/UsingUTF8Proc/test19_fuzz_test.ring`: random text and invalid UTF-8 checked with rules that must always hold (for example: the grapheme clusters joined give the original string, wrapped lines are not wider than the width)
- The C code compiles without warnings using `cl /W4` (x64 and x86) and `-Wall -Wextra` (Linux, macOS x64 and arm64)

## Notes for the Code Generator

- Write C comments in `utf8proc.cf` without the `#` character: the code generator treats `#` as the start of a Ring comment and removes the rest of the line (including a closing `*/`).
- The code generator removes `#ifndef` and `#endif` lines, so `UTF8PROC_STATIC` is defined by the build scripts.

## Constants

- Options: `UTF8PROC_NULLTERM`, `UTF8PROC_STABLE`, `UTF8PROC_COMPAT`, `UTF8PROC_COMPOSE`, `UTF8PROC_DECOMPOSE`, `UTF8PROC_IGNORE`, `UTF8PROC_REJECTNA`, `UTF8PROC_NLF2LS`, `UTF8PROC_NLF2PS`, `UTF8PROC_NLF2LF`, `UTF8PROC_STRIPCC`, `UTF8PROC_CASEFOLD`, `UTF8PROC_CHARBOUND`, `UTF8PROC_LUMP`, `UTF8PROC_STRIPMARK`, `UTF8PROC_STRIPNA`
- Errors: `UTF8PROC_ERROR_NOMEM`, `UTF8PROC_ERROR_OVERFLOW`, `UTF8PROC_ERROR_INVALIDUTF8`, `UTF8PROC_ERROR_NOTASSIGNED`, `UTF8PROC_ERROR_INVALIDOPTS`
- Version: `UTF8PROC_VERSION_MAJOR`, `UTF8PROC_VERSION_MINOR`, `UTF8PROC_VERSION_PATCH`
- Arabic shaping and visual order: `RING_UTF8PROC_FORM*`, `RING_UTF8PROC_JOIN*`, `RING_UTF8PROC_DIRECTION*`
- `UTF8PROC_CATEGORY_*`, `UTF8PROC_BIDI_CLASS_*`, `UTF8PROC_DECOMP_TYPE_*`, `UTF8PROC_BOUNDCLASS_*`, `UTF8PROC_INDIC_CONJUNCT_BREAK_*`

## License

The extension is released under the MIT License. utf8proc is released under the MIT "expat" License (see `utf8proc/LICENSE.md`).
