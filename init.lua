-- vim.cmd([[set runtimepath^=~/.vim runtimepath+=~/.vim/after]])
print(vim.o.runtimepath)
vim.o.runtimepath = '~/.vim,' .. vim.o.runtimepath .. ',~/.vim/after'
print(vim.o.runtimepath)
vim.cmd([[let &packpath=&runtimepath]])
vim.cmd([[source ~/.vimrc]])
local api = vim.api
-- api.nvim_echo({{"hello, I'm lua init file!",""}}, false, {})
--api.nvim_echo({{"hello, I'm lua init file! - s!",""}}, true, {})
---- print "hello, neovim lua!"
----
--
--cmd = [[something like
--go's ``(backticks surrounded strings),
--you can see it! space ]]
--print(cmd)
--
-- :help api.txt
-- api.nvim_win_set_option(0, "number", true)
-- api.nvim_win_set_option(0, "relativenumber",true)
-- print(vim.inspect(api.nvim_list_runtime_paths()))

api.nvim_set_var("coc_global_extensions", {"coc-clangd", "coc-json", "coc-webview", "coc-markdown-preview-enhanced", "coc-vimlsp"})
api.nvim_set_keymap('n', '[g', '<Plug>(coc-diagnostic-prev)', {})
api.nvim_set_keymap('n', ']g', '<Plug>(coc-diagnostic-next)', {})

api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', {silent = true})
api.nvim_set_keymap('n', 'gy', '<Plug>(coc-type-definition)', {silent = true})
api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', {silent = true})
api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', {silent = true})

api.nvim_set_keymap('n', 'K', ':call ShowDocumentation()<CR>', {silent = true, noremap = true})
api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], {noremap = true})

-- function _G.test()
--     print("test")
-- end
-- api.nvim_buf_set_keymap(0, 'n', 'xs', [[<cmd>v:lua.test()]<CR>]], {noremap = true})


vim.cmd([[
function! ShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
]])

vim.cmd(
[[augroup MarkDown
    autocmd!
    autocmd FileType markdown nnoremap <buffer> <F5> :CocCommand markdown-preview-enhanced.openPreview<CR>

augroup END]]
)
--[[

" Use <c-space> to trigger completion.
if has('nvim')
  " inoremap <silent><expr> <c-space> coc#refresh()
  inoremap <silent><expr> <c-l> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
--]]
