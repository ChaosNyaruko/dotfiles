hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
    hs.reload()
end)
hs.alert.show("Config loaded")

hs.hotkey.bind({ "cmd", "alt" }, "H", function()
    -- hint
    local keybinding_hints = [[
    windows movement:
        cmd + alt + Left/Right/Up/Down
    WindowHalfsAndThirds:
        left_half   = { {"ctrl",        "cmd"}, "Left" },
        right_half  = { {"ctrl",        "cmd"}, "Right" },
        top_half    = { {"ctrl",        "cmd"}, "Up" },
        bottom_half = { {"ctrl",        "cmd"}, "Down" },
        third_left  = { {"ctrl", "alt"       }, "Left" },
        third_right = { {"ctrl", "alt"       }, "Right" },
        third_up    = { {"ctrl", "alt"       }, "Up" },
        third_down  = { {"ctrl", "alt"       }, "Down" },
        top_left    = { {"ctrl",        "cmd"}, "1" },
        top_right   = { {"ctrl",        "cmd"}, "2" },
        bottom_left = { {"ctrl",        "cmd"}, "3" },
        bottom_right= { {"ctrl",        "cmd"}, "4" },
        max_toggle  = { {"ctrl", "alt", "cmd"}, "f" },
        max         = { {"ctrl", "alt", "cmd"}, "Up" },
        undo        = { {        "alt", "cmd"}, "z" },
        center      = { {        "alt", "cmd"}, "c" },
        larger      = { {        "alt", "cmd", "shift"}, "Right" },
        smaller     = { {        "alt", "cmd", "shift"}, "Left" },
    ]]
    hs.alert.show(keybinding_hints)
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

hs.hotkey.bind({ "alt" }, "d", function()
    local btn, word = hs.dialog.textPrompt("ondict", "input word:", "doctor", "OK", "Cancel")
    if btn == "Cancel" then
        return
    end
    -- local cb = function(code, stdout, stderr)
    --     -- hs.alert(string.format("ondict[%d]:%s", code, stdout))
    --     hs.webview.newBrowser(hs.geometry.rect(800, 600, 450, 450)):html(stdout):show()
    -- end
    -- local bin_loc = os.getenv("HOME") .. "/go/bin/ondict"
    -- print(string.format("loading ondict from %s", bin_loc))
    -- local ondict = hs.task.new(bin_loc, cb,
    --     { "-remote=localhost:1345", "-q", word, "-e=mdx", "-f=html" })
    -- if ondict == nil then
    --     hs.alert("bad new task")
    --     return
    -- end
    -- -- hs.timer.doEvery(1, function ()
    -- --     print(ondict:pid())
    -- -- end)
    -- ondict:start()
    local cmd = [["ondict" "-q" ']] .. word .. [[' "-remote" "localhost:1345" "-e" "mdx" "-f" "html" ]]
    -- print(output)
    -- print(status)
    -- print(t)
    -- print(c)
    print(cmd)
    local output, status, t, c = hs.execute(cmd, true)
    hs.webview.newBrowser(hs.geometry.rect(800, 600, 450, 450)):html(output):show()
end)

hs.hotkey.bind({"alt" }, "e", function ()
    print(hs.inspect(hs.audiodevice.allOutputDevices()))
end)
