-- Hyper key: F19 (CapsLock is remapped to F19 via hidutil LaunchAgent)
hs.window.animationDuration = 0

local hyper = hs.hotkey.modal.new()
hs.hotkey.bind({}, "f19", function() hyper:enter() end, function() hyper:exit() end)

-- Open if not running, otherwise activate
local apps = {
  v = "com.microsoft.VSCode",
  x = "com.anysphere.sand",          -- Grok Bot
  s = "com.github.wez.wezterm",
  c = "com.mitchellh.ghostty",
  f = "org.mozilla.firefox",
  g = "com.openai.codex",              -- ChatGPT
  w = "com.tencent.xinWeChat",        -- WeChat
  b = "com.bitwarden.desktop",
  z = "dev.zed.Zed",                  -- Zed
}
for key, bundle in pairs(apps) do
  hyper:bind({}, key, function()
    if not hs.application.launchOrFocusByBundleID(bundle) then
      hs.alert.show("未安装: " .. bundle)
    end
  end)
end

-- Half-screen layouts
local function place(unit)
  local win = hs.window.focusedWindow()
  if win then win:moveToUnit(unit) end
end
hyper:bind({}, "up",    function() place({0, 0, 1, 0.5}) end)
hyper:bind({}, "down",  function() place({0, 0.5, 1, 0.5}) end)
hyper:bind({}, "left",  function() place({0, 0, 0.5, 1}) end)
hyper:bind({}, "right", function() place({0.5, 0, 0.5, 1}) end)

-- Move focused window to the screen on the left / right
local function toScreen(dir)
  local win = hs.window.focusedWindow()
  if not win then return end
  local target = dir == "west" and win:screen():toWest() or win:screen():toEast()
  if target then win:moveToScreen(target, false, true) end
end
hyper:bind({"alt"}, "left",  function() toScreen("west") end)
hyper:bind({"alt"}, "right", function() toScreen("east") end)

-- Fill the screen (maximize, not native fullscreen)
hyper:bind({"alt"}, "f", function() place({0, 0, 1, 1}) end)

hs.alert.show("Hammerspoon config loaded")
