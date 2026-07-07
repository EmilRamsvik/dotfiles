-- Clipboard → Obsidian inbox. Appends the clipboard with a timestamp and
-- the source app to the note at config.obsidianInbox.
--
-- Replaces the Keyboard Maestro "add clipboard to inbox note" macro: the
-- ⌘⌥⇧R chord that Karabiner's tab+i sends (see karabiner.edn) now lands
-- here instead of in KM.

local config = require("config")

local M = {}

local function appendClipboard()
  local contents = hs.pasteboard.getContents()
  if not contents or contents == "" then
    hs.alert.show("Clipboard is empty")
    return
  end

  local front = hs.application.frontmostApplication()
  local source = front and front:name() or "unknown"

  local f, err = io.open(config.obsidianInbox, "a")
  if not f then
    hs.alert.show("Could not open inbox note: " .. tostring(err))
    return
  end
  -- indent continuation lines so multi-line clips stay inside the bullet
  local body = contents:gsub("\n", "\n  ")
  f:write(("\n- %s (from %s)\n  %s\n"):format(os.date("%Y-%m-%d %H:%M"), source, body))
  f:close()

  hs.alert.show("Added to inbox 📥")
end

function M.init(hyper)
  hs.hotkey.bind(hyper, "i", appendClipboard)
  -- the chord Karabiner sends for tab+i (formerly a Keyboard Maestro hotkey)
  hs.hotkey.bind({ "cmd", "alt", "shift" }, "r", appendClipboard)
end

return M
