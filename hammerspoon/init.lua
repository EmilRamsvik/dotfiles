-- Hammerspoon configuration, symlinked to ~/.hammerspoon by setup.sh.
--
-- Hyper (⌘⌃⌥⇧) is produced by holding the right command key — see the
-- "hyper key" rule in Karabiner/karabiner.edn. Every binding hung off
-- `hyper` is guaranteed conflict-free with normal app shortcuts.
--
-- Machine-specific settings (paths, app names, routes): config.lua
--
-- Hyper bindings:
--   letters (see config.appToggles)  focus/hide apps
--   b        web search prompt          space    Spotify now playing
--   i        clipboard → Obsidian inbox ←/→      Spotify prev/next track
--   p        pomodoro start/stop        1 / 2    coding / communication layout
--   r        reload this config

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

require("apps").init(hyper) -- app focus-toggles
require("search").init(hyper) -- hyper+b web search prompt
require("spotify").init(hyper) -- now-playing HUD + track skipping
require("inbox").init(hyper) -- clipboard → Obsidian inbox
require("pomodoro").init(hyper) -- menubar timer (replaces TomatoBar)
require("urls").init() -- URL dispatcher (default browser routing)
require("layouts").init(hyper) -- window layouts + docking watcher

hs.alert.show("Hammerspoon config loaded")
