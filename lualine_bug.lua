local notify = function(msg)
    print("notify is called")
    vim.notify(msg, vim.log.levels.ERROR)
end

-- notify(string.format("ondict error %s", os.date()), vim.log.levels.ERROR)
local function test()
    vim.fn.jobstart({"bash", "xxx"}, {
        on_stdout = function ()
        end,
        on_stderr = function ()
        end,
        on_exit = function(_, status, _)
            -- ONLY when on_stdout and on_stderr are both nil, the ERROR msg can work as expected, otherwise ERROR msg will not be displayed
            notify(string.format("ondict error %s", os.date()))
        end
    })
end
test()
