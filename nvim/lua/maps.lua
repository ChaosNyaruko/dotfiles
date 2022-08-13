local keymap = vim.keymap

nopts = {noremap=true}

keymap.set('v', '<', '<gv', nopts)
keymap.set('v', '>', '>gv', nopts)

keymap.set('n', '<leader>sv', ':source $MYVIMRC<cr>', nopts)
keymap.set('n', '<leader>ev', ':vsp $MYVIMRC<cr>', nopts)
