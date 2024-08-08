#Requires AutoHotkey v2.0
#SingleInstance Force

#b:: ShowSearchGUI()

ShowSearchGUI() {
    searchGui := Gui()
    searchGui.Opt("+AlwaysOnTop -SysMenu +Owner")
    searchGui.Title := "Quick Google Search"

    edit := searchGui.Add("Edit", "w300 vSearchText")

    mybtn := searchGui.Add("Button", "Default w80", "OK")
    mybtn.OnEvent("Click", (*) => HandleSubmit(searchGui))  ; Corrected this line

    searchGui.OnEvent("Escape", (*) => searchGui.Destroy())
    searchGui.OnEvent("Close", (*) => searchGui.Destroy())

    searchGui.Show()
    edit.Focus()
}

HandleSubmit(thisGui, *) {
    searchText := thisGui["SearchText"].Value
    if (searchText != "") {
        Run "https://www.google.com/search?q=" . UrlEncode(searchText)
        thisGui.Destroy()
    }
}

UrlEncode(str) {
    return StrReplace(StrReplace(StrReplace(str, "%", "%25"), "&", "%26"), "+", "%2B")
}