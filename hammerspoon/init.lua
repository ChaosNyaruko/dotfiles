hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
    hs.reload()
end)
hs.alert.show("Config loaded")

hs.hotkey.bind({ "cmd", "alt" }, "W", function()
    hs.alert.show("Hello world")
end)

hs.hotkey.bind({ "cmd", "alt" }, "Left", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()

    f.x = f.x - 10
    win:setFrame(f)
end)

hs.hotkey.bind({ "cmd", "alt" }, "Right", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()

    f.x = f.x + 10
    win:setFrame(f)
end)

hs.hotkey.bind({ "cmd", "alt" }, "Up", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()

    f.y = f.y - 10
    win:setFrame(f)
end)

hs.hotkey.bind({ "cmd", "alt" }, "Down", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()

    f.y = f.y + 10
    win:setFrame(f)
end)

hs.loadSpoon("WindowHalfsAndThirds")
spoon.WindowHalfsAndThirds:bindHotkeys(spoon.WindowHalfsAndThirds.defaultHotkeys)
