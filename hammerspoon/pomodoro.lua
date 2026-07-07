-- Menubar pomodoro timer. Replaces TomatoBar: the ⌘⌥⇧T chord that
-- Karabiner's tab+o sends (see karabiner.edn) toggles this timer, as does
-- hyper+p or clicking the menubar icon.

local config = require("config")

local M = {}

local menubar
local timer
local remaining = 0
local onBreak = false

local function updateTitle()
  if not menubar then
    return
  end
  if timer then
    menubar:setTitle(("%s %d:%02d"):format(onBreak and "☕" or "🍅", math.floor(remaining / 60), remaining % 60))
  else
    menubar:setTitle("🍅")
  end
end

local function stop()
  if timer then
    timer:stop()
    timer = nil
  end
  onBreak = false
  updateTitle()
end

local startPhase

local function tick()
  remaining = remaining - 1
  if remaining > 0 then
    updateTitle()
    return
  end
  if onBreak then
    hs.alert.show("Break over — back to work 🍅")
    stop()
  else
    hs.alert.show("Pomodoro done — take a break ☕")
    startPhase(config.pomodoro.breakMinutes * 60, true)
  end
end

startPhase = function(seconds, isBreak)
  if timer then
    timer:stop()
  end
  remaining = seconds
  onBreak = isBreak
  timer = hs.timer.doEvery(1, tick)
  updateTitle()
end

local function toggle()
  if timer then
    hs.alert.show("Pomodoro stopped")
    stop()
  else
    hs.alert.show(("Pomodoro started (%d min)"):format(config.pomodoro.workMinutes))
    startPhase(config.pomodoro.workMinutes * 60, false)
  end
end

function M.init(hyper)
  menubar = hs.menubar.new()
  menubar:setClickCallback(toggle)
  updateTitle()
  hs.hotkey.bind(hyper, "p", toggle)
  -- the chord Karabiner sends for tab+o (formerly toggled TomatoBar via KM)
  hs.hotkey.bind({ "cmd", "alt", "shift" }, "t", toggle)
end

return M
