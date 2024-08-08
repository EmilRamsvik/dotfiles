#Requires AutoHotkey v2.0

; Text Expansions
::btw::by the way
::vira:: ; for vim replace all
{
    SendText "%s///g"
    Send "{Left 3}"
}
::vir:: ; for vim replace
{
    SendText "s///"
    Send "{Left 2}"
}


; mail, phone etc. - all the shortcuts start with q
::qtlf::
{
    SendText "+47 40485895"
}
::qmail::emil.ramsvik@gmail.com
::qname::+Emil Severin Ramsvik
::qinit:: EIRW


; python related shortcuts
::pipi::pip install
::pipu::pip install --upgrade