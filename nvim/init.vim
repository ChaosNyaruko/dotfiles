" This file is supposed to be used for NeoVim, typically put in ~/.config/nvim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
set guicursor=i:block

au Filetype cpp source ~/.config/nvim/scripts/spacetab.vim
au Filetype cpp set colorcolumn=100
au TextYankPost * silent! lua vim.highlight.on_yank() " Highlight yank

 " Leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste

" Prevent accidental writes to buffers that shouldn't be edited
autocmd BufRead *.orig set readonly
autocmd BufRead *.pacnew set readonly

lua <<EOF
require("plugins")
vim.api.nvim_set_keymap('i', '<c-n>', '<Down>', {noremap = true})
vim.api.nvim_set_keymap('i', '<c-p>', '<Up>', {noremap = true})
EOF
