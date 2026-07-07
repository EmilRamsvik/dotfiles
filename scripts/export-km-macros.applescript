-- Export every Keyboard Maestro macro group as a diffable XML (.kmmacros)
-- file into the directory given as the first argument.
-- Requires Keyboard Maestro 9 or later (the `xml` property on macro groups).
--
-- Usage: osascript export-km-macros.applescript /path/to/output/dir

on run argv
	set outDir to item 1 of argv
	tell application "Keyboard Maestro"
		set groupList to every macro group
		repeat with g in groupList
			set gName to name of g
			set gXML to xml of g
			set safeName to my sanitize(gName)
			my writeFile(outDir & "/" & safeName & ".kmmacros", gXML)
		end repeat
	end tell
end run

-- Replace characters that are illegal or awkward in file names
on sanitize(t)
	repeat with c in {"/", ":"}
		set AppleScript's text item delimiters to (contents of c)
		set parts to text items of t
		set AppleScript's text item delimiters to "-"
		set t to parts as text
	end repeat
	set AppleScript's text item delimiters to ""
	return t
end sanitize

on writeFile(posixPath, txt)
	set f to open for access (POSIX file posixPath) with write permission
	try
		set eof of f to 0
		write txt to f as «class utf8»
		close access f
	on error errMsg number errNum
		close access f
		error errMsg number errNum
	end try
end writeFile
