local M = {}

---@return string | nil
M.get_content = function()
    local output = vim.fn.system("pbpaste")
    local exit_code = vim.v.shell_error
    print("exit_code: ", exit_code, "output:", output)

    if exit_code == 0 then
        return output:match("^[^\n]+")
    end

    return nil
end
return M
