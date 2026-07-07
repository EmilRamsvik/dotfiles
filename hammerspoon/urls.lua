-- URL dispatcher. Hammerspoon registers itself as the system's default
-- browser (macOS asks you to confirm the first time) and routes every link:
-- hosts matching a pattern in config.urlRoutes open in that app, everything
-- else opens in config.defaultBrowser.
--
-- To stop dispatching, comment out require("urls") in init.lua and pick a
-- real browser in System Settings → Desktop & Dock → Default web browser.

local config = require("config")

local M = {}

local function openIn(appName, url)
  hs.task.new("/usr/bin/open", nil, { "-a", appName, url }):start()
end

-- Route a URL through the rules. Also used by search.lua, so searches obey
-- the same routing as clicked links.
function M.open(url)
  local host = url:match("^%a[%w+.-]*://([^/:]+)") or ""
  for pattern, appName in pairs(config.urlRoutes) do
    if host:match(pattern) then
      openIn(appName, url)
      return
    end
  end
  openIn(config.defaultBrowser, url)
end

function M.init()
  hs.urlevent.httpCallback = function(_, _, _, fullURL)
    if fullURL then M.open(fullURL) end
  end
  hs.urlevent.setDefaultHandler("http")
end

return M
