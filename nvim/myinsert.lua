vim.keymap.set('n', 'x', function()
  vim.api.nvim_paste([[
    line1
    line2
    line3
  ]], false, -1)
end, { buffer = true })

