-- print("plugin/test.lua loaded")
vim.keymap.set("n", "<leader>t", function()
    vim.cmd.tabnew()
    vim.fn.termopen(vim.o.shell, { cwd = vim.fn.expand('%:p:h') })
    vim.cmd [[startinsert]]
end)
