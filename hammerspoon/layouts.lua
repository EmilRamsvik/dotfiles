-- Window layouts + monitor-docking watcher.
--
--   hyper+1  "coding":        editor left ⅔ + terminal right ⅓ on the main
--                             screen; chat and music parked on the laptop
--                             screen when an external monitor is connected
--   hyper+2  "communication": chat left ½, messages right ½ on the main screen
--
-- A screen watcher applies the coding layout automatically when an external
-- monitor connects, and maximizes the core apps when it disconnects.
--
-- This is also the replacement path for Rectangle: point the Karabiner
-- w-layer at functions here instead of Rectangle hotkeys once trusted.

local config = require("config")

local M = {}

local RECT = {
  left23 = { x = 0, y = 0, w = 2 / 3, h = 1 },
  right13 = { x = 2 / 3, y = 0, w = 1 / 3, h = 1 },
  left12 = { x = 0, y = 0, w = 0.5, h = 1 },
  right12 = { x = 0.5, y = 0, w = 0.5, h = 1 },
  full = { x = 0, y = 0, w = 1, h = 1 },
}

-- Returns laptop screen and (if present) the first external screen
local function screens()
  local laptop, external
  for _, s in ipairs(hs.screen.allScreens()) do
    if (s:name() or ""):match("Built%-in") then
      laptop = s
    else
      external = external or s
    end
  end
  return laptop or hs.screen.primaryScreen(), external
end

function M.coding()
  local laptop, external = screens()
  local main = external or laptop
  local layout = {
    { config.apps.editor, nil, main, RECT.left23, nil, nil },
    { config.apps.terminal, nil, main, RECT.right13, nil, nil },
  }
  if external then
    table.insert(layout, { config.apps.chat, nil, laptop, RECT.full, nil, nil })
    table.insert(layout, { config.apps.music, nil, laptop, RECT.full, nil, nil })
  end
  hs.layout.apply(layout)
  hs.alert.show("Layout: coding")
end

function M.communication()
  local laptop, external = screens()
  local main = external or laptop
  hs.layout.apply({
    { config.apps.chat, nil, main, RECT.left12, nil, nil },
    { config.apps.messages, nil, main, RECT.right12, nil, nil },
  })
  hs.alert.show("Layout: communication")
end

function M.undocked()
  local laptop = screens()
  local layout = {}
  for _, appName in pairs(config.apps) do
    table.insert(layout, { appName, nil, laptop, RECT.full, nil, nil })
  end
  hs.layout.apply(layout)
  hs.alert.show("Layout: undocked")
end

local watcher
local debounce

function M.init(hyper)
  hs.hotkey.bind(hyper, "1", M.coding)
  hs.hotkey.bind(hyper, "2", M.communication)

  watcher = hs.screen.watcher.new(function()
    -- screen events fire in bursts while displays settle; act once they stop
    if debounce then
      debounce:stop()
    end
    debounce = hs.timer.doAfter(3, function()
      local _, external = screens()
      if external then
        M.coding()
      else
        M.undocked()
      end
    end)
  end)
  watcher:start()
end

return M
