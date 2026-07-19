local M = {}

local CURSOR = "<CURSOR>"

M.input = function(args)
    local completed, output = pcall(function()
        return vim.fn.input(args)
    end)

    if not completed then
        return nil
    end

    return output
end

function M.get_new_cursor_col(line)
    local cursor_pos = line:find("CURSOR")
    if cursor_pos then
        return cursor_pos - 1
    end

    return string.len(line) - 1
end

M.insert_url = function()
    local template = string.format("[](%s)", CURSOR)
    local url = M.input({
        prompt = "url: ",
    })

    if not url or url == '' then
        vim.notify("empty input", vim.log.levels.WARN)
        url = require("U.clipboard").get_content()
    end

    local cur_pos = vim.api.nvim_win_get_cursor(0)
    local cur_row = cur_pos[1]

    url = template:gsub(CURSOR, url)
    vim.api.nvim_put({ url }, "l", false, true)


    vim.api.nvim_win_set_cursor(0, { cur_row, 0 })
    if vim.api.nvim_get_mode().mode ~= "i" then
        vim.api.nvim_input("a")
    end
end

return M
