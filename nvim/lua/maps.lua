local keymap = vim.keymap

local nopts = { noremap = true }

keymap.set('v', '<', '<gv', nopts)
keymap.set('v', '>', '>gv', nopts)

keymap.set('n', '<leader>sv', ':source $MYVIMRC<cr>', nopts)
keymap.set('n', '<leader>ev', ':vsp $MYVIMRC<cr>', nopts)

keymap.set('t', '<esc>', '<c-\\><c-n>', nopts)

function _G.ToggleEmacs()
    if vim.g.emacs_mapping == 1 then
        vim.cmd [[    iunmap <C-f>
        iunmap <C-b>
        iunmap <C-n>
        iunmap <C-p>
        iunmap <C-a>
        iunmap <C-e>
        iunmap <C-k>
        iunmap <A-f>
        ]]
        vim.g.emacs_mapping = 0
    else
        vim.cmd [[inoremap <C-f> <Right>
    inoremap <C-b> <Left>
    inoremap <C-n> <Down>
    inoremap <C-p> <Up>
    inoremap <C-a> <Home>
    inoremap <C-e> <End>
    inoremap <C-k> <esc>d$a
    inoremap <A-f> <esc>ea]]
        vim.g.emacs_mapping = 1
    end
end

vim.cmd [[
command! -nargs=0 Emacs call v:lua.ToggleEmacs()
]]
