#Requires AutoHotkey v2.0


; CAPSLOCK Disable
SetCapsLockState "AlwaysOff"
CapsLock::Esc
CapsLock & i:: Send "^{Backspace}"
CapsLock & h:: Send "{Left}"
CapsLock & j:: Send "{Down}"
CapsLock & k:: Send "{Up}"
CapsLock & l:: Send "{Right}"

; Make the move
CapsLock & å:: Send "{PgUp}"
CapsLock & ø:: Send "{PgDn}"

CapsLock & w:: Send "^{Right}"
CapsLock & b:: Send "^{Left}"
CapsLock & p:: Send "#v"
CapsLock & o:: Send "^v"
CapsLock & u:: Send "^z"


CapsLock & m:: Send "["
CapsLock & n:: Send "{{}"

Shift & 4:: Send "{$}"


|::<
Shift & |:: Send ">"

'::@
Shift & ':: Send "*"

<::'
Shift & <:: Send "|"
½::<