-- App focus-toggles on the hyper key: focus the app, or hide it when it is
-- already frontmost. Unlike the Karabiner q-layer (which only launches),
-- this gives instant bounce between editor ⇄ terminal ⇄ notes and back.

local config = require("config")

local M = {}

local function toggle(appName)
  return function()
    local app = hs.application.get(appName)
    if app and app:isFrontmost() then
      app:hide()
    else
      hs.application.launchOrFocus(appName)
    end
  end
end

function M.init(hyper)
  for key, appName in pairs(config.appToggles) do
    hs.hotkey.bind(hyper, key, toggle(appName))
  end
end

return M
