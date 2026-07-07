-- Quick web search (hyper+b): a Spotlight-style prompt that searches Google,
-- or opens the input directly when it looks like a URL. macOS port of
-- autohotkey/google_search.ahk (Win+B on Windows).

local config = require("config")
local urls = require("urls")

local M = {}

local chooser

local function onChoice(choice)
  if choice and choice.url then
    urls.open(choice.url)
  end
end

local function onQueryChanged(query)
  if query == "" then
    chooser:choices({})
    return
  end
  local choices = {
    {
      text = 'Search Google for "' .. query .. '"',
      subText = "opens in " .. config.defaultBrowser,
      url = "https://www.google.com/search?q=" .. hs.http.encodeForQuery(query),
    },
  }
  if query:match("^https?://") or query:match("^[%w-]+%.[%w-][%w.-]*$") then
    local url = query:match("^https?://") and query or ("https://" .. query)
    table.insert(choices, 1, { text = "Open " .. url, subText = "direct URL", url = url })
  end
  chooser:choices(choices)
end

function M.init(hyper)
  chooser = hs.chooser.new(onChoice)
  chooser:placeholderText("Search Google or enter a URL…")
  chooser:queryChangedCallback(onQueryChanged)
  hs.hotkey.bind(hyper, "b", function()
    chooser:query("")
    chooser:show()
  end)
end

return M
