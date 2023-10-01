" This file is supposed to be used for NeoVim, typically put in ~/.config/nvim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
" set guicursor=i:block

au Filetype cpp source ~/.config/nvim/scripts/spacetab.vim
au Filetype cpp set colorcolumn=100
au TextYankPost * silent! lua vim.highlight.on_yank() " Highlight yank

 " Leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste

" Prevent accidental writes to buffers that shouldn't be edited
autocmd BufRead *.orig set readonly
autocmd BufRead *.pacnew set readonly

lua <<EOF
-- require("plugins")
require("lazy-manager")
-- require("mydict")
-- vim.api.nvim_set_keymap('i', '<c-n>', '<cmd>normal! g<Down><cr>', {noremap = true})
-- vim.api.nvim_set_keymap('i', '<c-p>', '<cmd>normal! g<Up><cr>', {noremap = true})
EOF

" if ! exists("g:CheckUpdateStarted")
"     let g:CheckUpdateStarted=1
"     call timer_start(1,'CheckUpdate')
" endif
" function! CheckUpdate(timer)
"     silent! checktime
"     call timer_start(1000,'CheckUpdate')
" endfunction
" set noautoread
