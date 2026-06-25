local at_home = function()
    -- disable codeium at working because of security policy
    if os.getenv("HOME"):find("bill") then
        return true
    else
        return false
    end
end

local function get_audio_devices(kind)
    local devices = {}
    local source = {}

    if kind == "output" then
        source = hs.audiodevice.allOutputDevices()
    elseif kind == "input" then
        source = hs.audiodevice.allInputDevices()
    else
        return devices
    end

    for _, device in ipairs(source) do
        if device:name() and device:uid() then
            table.insert(devices, device)
        end
    end

    table.sort(devices, function(a, b)
        return a:name():lower() < b:name():lower()
    end)

    return devices
end

local function get_default_audio_device(kind)
    if kind == "output" then
        return hs.audiodevice.defaultOutputDevice()
    elseif kind == "input" then
        return hs.audiodevice.defaultInputDevice()
    end
end

local function set_default_audio_device(kind, device)
    if kind == "output" then
        return device:setDefaultOutputDevice()
    elseif kind == "input" then
        return device:setDefaultInputDevice()
    end
end

local function list_audio_devices(kind)
    local devices = get_audio_devices(kind)
    local current = get_default_audio_device(kind)
    local current_uid = current and current:uid() or nil
    local title = kind == "output" and "Output devices" or "Input devices"

    if #devices == 0 then
        hs.alert.show("No " .. kind .. " devices found")
        return
    end

    local names = {}
    for _, device in ipairs(devices) do
        local prefix = device:uid() == current_uid and "* " or "  "
        table.insert(names, prefix .. device:name())
    end

    hs.alert.show(title .. "\n" .. table.concat(names, "\n"), 3)
end

local function cycle_audio_device(kind)
    local devices = get_audio_devices(kind)
    local label = kind == "output" and "Audio output" or "Microphone"

    if #devices == 0 then
        hs.alert.show("No " .. kind .. " devices found")
        return
    end

    local current = get_default_audio_device(kind)
    local current_uid = current and current:uid() or nil
    local next_index = 1

    for index, device in ipairs(devices) do
        if device:uid() == current_uid then
            next_index = (index % #devices) + 1
            break
        end
    end

    local next_device = devices[next_index]
    local ok = set_default_audio_device(kind, next_device)

    if ok then
        hs.alert.show(label .. ": " .. next_device:name())
    else
        hs.alert.show("Failed to switch " .. kind .. " device")
    end
end

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
    hs.reload()
end)
hs.alert.show("Config loaded")

hs.hotkey.bind({ "cmd", "alt" }, "H", function()
    -- hint
    local keybinding_hints = [[
    windows movement:
        cmd + alt + Left/Right/Up/Down
    audio:
        cmd + e            cycle output device
        cmd + shift + e    list output devices
        cmd + alt + e      cycle input device
        cmd + alt + shift + e
                          list input devices
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
    local bin_loc = os.getenv("HOME") .. "/go/bin/ondict"
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
    local remote = "localhost:1345"
    if not at_home() then
        remote = "mini.freecloud.dev:443"
    end
    local cmd = bin_loc .. [[ "-q" ']] .. word .. [[' "-remote" ]] .. remote .. [[ "-e" "mdx" "-f" "html" "-r" "2"]]
    print(cmd)
    -- print(output)
    -- print(status)
    -- print(t)
    -- print(c)
    local output, status, t, c = hs.execute(cmd, false)
    hs.webview.newBrowser(hs.geometry.rect(800, 600, 450, 450)):html(output):show()
end)

hs.hotkey.bind({ "cmd" }, "e", function()
    cycle_audio_device("input")
end)

hs.hotkey.bind({ "cmd", "shift" }, "e", function()
    cycle_audio_device("output")
end)

hs.hotkey.bind({ "cmd", "alt" }, "e", function()
    list_audio_devices("input")
end)

hs.hotkey.bind({ "cmd", "alt", "shift" }, "e", function()
    list_audio_devices("output")
end)


hs.hotkey.bind({ "cmd", "shift" }, "x", function()
    local win = hs.window.focusedWindow()
    local screens = hs.screen.allScreens()
    local currentScreen = win:screen()

    -- Find index of current screen
    local idx = 1
    for i, s in ipairs(screens) do
        if s == currentScreen then
            idx = i
            break
        end
    end

    -- Move to next screen (wraps around)
    local nextScreen = screens[(idx % #screens) + 1]
    win:moveToScreen(nextScreen, true, true)
end)


hs.hotkey.bind({"cmd", "shift"}, "x", function()
  local win = hs.window.focusedWindow()
  local screens = hs.screen.allScreens()
  local currentScreen = win:screen()
  
  -- Find index of current screen
  local idx = 1
  for i, s in ipairs(screens) do
    if s == currentScreen then
      idx = i
      break
    end
  end
  
  -- Move to next screen (wraps around)
  local nextScreen = screens[(idx % #screens) + 1]
  win:moveToScreen(nextScreen, true, true)
end)
