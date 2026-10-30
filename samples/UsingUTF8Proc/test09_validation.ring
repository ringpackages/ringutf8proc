# Validating UTF-8 and handling errors

load "utf8proclib.ring"

func main
	unicodeSetupConsole()

	aTexts = [
		["Valid text", "Unicode ✓"],
		["Truncated sequence", "abc" + char(0xE2) + char(0x82)],
		["Invalid byte", "abc" + char(0xFF) + "def"],
		["Overlong encoding", char(0xC0) + char(0xAF)],
		["Encoded surrogate", char(0xED) + char(0xA0) + char(0x80)]
	]

	nCount = len(aTexts)
	for x = 1 to nCount
		cText = aTexts[x][2]
		? unicodePadRight(aTexts[x][1], 20) + ": valid = " + unicodeIsValid(cText) +
		  "  fixed = " + unicodeFixInvalid(cText)
	next
	? ""

	# Functions that process text raise an error for invalid UTF-8
	try
		unicodeNFC("abc" + char(0xFF))
	catch
		? "Error: " + cCatchError
	done

	# Invalid option combinations are reported too
	try
		utf8proc_map("text", UTF8PROC_COMPOSE | UTF8PROC_DECOMPOSE)
	catch
		? "Error: " + cCatchError
	done
	? ""

	# Error messages of the error codes
	aErrors = [UTF8PROC_ERROR_NOMEM, UTF8PROC_ERROR_OVERFLOW, UTF8PROC_ERROR_INVALIDUTF8,
		   UTF8PROC_ERROR_NOTASSIGNED, UTF8PROC_ERROR_INVALIDOPTS]
	nCount = len(aErrors)
	for x = 1 to nCount
		? "" + aErrors[x] + " : " + utf8proc_errmsg(aErrors[x])
	next
