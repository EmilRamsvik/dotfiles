-- Hammerspoon configuration, symlinked to ~/.hammerspoon by setup.sh.
--
-- Hyper (⌘⌃⌥⇧) is produced by holding the right command key — see the
-- "hyper key" rule in Karabiner/karabiner.edn. Every binding hung off
-- `hyper` is guaranteed conflict-free with normal app shortcuts.

local hyper = { "cmd", "ctrl", "alt", "shift" }

-- Reload config with hyper+r, and automatically when any .lua file changes
hs.hotkey.bind(hyper, "r", function()
  hs.reload()
end)

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function(files)
  for _, file in ipairs(files) do
    if file:sub(-4) == ".lua" then
      hs.reload()
      return
    end
  end
end):start()

-- Example: run something and save the result as a file under version control.
-- Anything Hammerspoon computes (window layouts, script output, clipboard
-- history, ...) can be written straight into the dotfiles repo:
--
-- hs.hotkey.bind(hyper, "s", function()
--   local output = hs.execute("date; system_profiler SPDisplaysDataType", true)
--   local f = io.open(os.getenv("HOME") .. "/dotfiles/output/display-info.txt", "w")
--   f:write(output)
--   f:close()
--   hs.alert.show("Saved to dotfiles/output/display-info.txt")
-- end)

hs.alert.show("Hammerspoon config loaded")
