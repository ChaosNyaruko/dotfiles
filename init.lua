local api = vim.api
api.nvim_echo({{"hello, I'm lua init file!",""}}, false, {})
api.nvim_echo({{"hello, I'm lua init file! - s!",""}}, true, {})
-- print "hello, neovim lua!"
--

cmd = [[something like
go's ``(backticks surrounded strings),
you can see it! space ]]
print(cmd)
