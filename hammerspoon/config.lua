-- All machine-specific / personal settings live here.
-- Every other module reads from this table, so this is the only file you
-- should need to edit when a path, app, or preference changes.

local config = {}

-- ---------------------------------------------------------------------------
-- Browsing
-- ---------------------------------------------------------------------------

-- Where links open by default. The URL dispatcher (urls.lua) makes
-- Hammerspoon the system URL handler and forwards everything here unless a
-- route below matches.
config.defaultBrowser = "Google Chrome"

-- Per-domain overrides: Lua pattern matched against the URL host → app name.
-- Escape literal dots with %. Examples:
config.urlRoutes = {
  -- ["dev%.azure%.com"] = "Google Chrome",
  -- ["localhost"] = "Helium",
  -- ["open%.spotify%.com"] = "Spotify",
}

-- ---------------------------------------------------------------------------
-- Apps
-- ---------------------------------------------------------------------------

-- hyper + key toggles the app: focus it, or hide it if already frontmost.
-- Letters mirror the Karabiner q-layer launcher for shared muscle memory.
-- (hyper+r is taken by "reload config", see init.lua)
config.appToggles = {
  j = "Zed",
  k = "Helium",
  l = "Ghostty",
  f = "Finder",
  s = "Spotify",
  n = "Obsidian",
  m = "Messages",
  e = "Claude",
  w = "Slack",
  g = "Google Chrome",
  c = "ChatGPT",
}

-- Roles used by the window layouts (layouts.lua)
config.apps = {
  editor = "Zed",
  terminal = "Ghostty",
  chat = "Slack",
  messages = "Messages",
  music = "Spotify",
}

-- ---------------------------------------------------------------------------
-- Obsidian inbox (inbox.lua)
-- ---------------------------------------------------------------------------

-- EDIT ME: absolute path to the inbox note inside your Obsidian vault.
config.obsidianInbox = os.getenv("HOME") .. "/Documents/notebooks/inbox.md"

-- ---------------------------------------------------------------------------
-- Pomodoro (pomodoro.lua)
-- ---------------------------------------------------------------------------

config.pomodoro = {
  workMinutes = 25,
  breakMinutes = 5,
}

return config
