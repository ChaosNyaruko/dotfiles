local gx_desc = 'Opens filepath or URI under cursor with the system handler (file explorer, web browser, …)'
local function do_open(uri)
    local cmd, err = vim.ui.open(uri)
    local rv = cmd and cmd:wait(1000) or nil
    if cmd and rv and rv.code ~= 0 then
        err = ('vim.ui.open: command %s (%d): %s'):format(
            (rv.code == 124 and 'timeout' or 'failed'),
            rv.code,
            vim.inspect(cmd.cmd)
        )
    end
    return err
end
do
    vim.keymap.set({ 'n' }, 'gx', function()
        for _, url in ipairs(require('vim.ui')._get_urls()) do
            local err = do_open(url)
            if err then
                vim.notify(err, vim.log.levels.ERROR)
            end
        end
    end, { desc = gx_desc })
    vim.keymap.set({ 'x' }, 'gx', function()
        local lines =
            vim.fn.getregion(vim.fn.getpos('.'), vim.fn.getpos('v'), { type = vim.fn.mode() })
        -- Trim whitespace on each line and concatenate.
        local err = do_open(table.concat(vim.iter(lines):map(vim.trim):totable()))
        if err then
            vim.notify(err, vim.log.levels.ERROR)
        end
    end, { desc = gx_desc })
end
