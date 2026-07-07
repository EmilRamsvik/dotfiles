-- Spotify HUD on the hyper key. Play/pause and shuffle stay on the media
-- keys (handled in Karabiner/karabiner.edn); this adds what those can't:
-- an on-screen now-playing display and track skipping with feedback.

local M = {}

local function showTrack()
  if hs.spotify.isRunning() then
    hs.spotify.displayCurrentTrack()
  else
    hs.alert.show("Spotify is not running")
  end
end

local function skip(direction)
  return function()
    if not hs.spotify.isRunning() then
      hs.alert.show("Spotify is not running")
      return
    end
    direction()
    hs.timer.doAfter(0.3, hs.spotify.displayCurrentTrack)
  end
end

function M.init(hyper)
  hs.hotkey.bind(hyper, "space", showTrack)
  hs.hotkey.bind(hyper, "right", skip(hs.spotify.next))
  hs.hotkey.bind(hyper, "left", skip(hs.spotify.previous))
end

return M
