-- print("plugin/test.lua loaded")
vim.keymap.set("n", "<leader>t", function()
    local cwd = vim.fn.expand('%:p:h')
    vim.cmd.tabnew()
    vim.fn.termopen(vim.o.shell, { cwd = cwd })
    vim.cmd [[startinsert]]
end)
