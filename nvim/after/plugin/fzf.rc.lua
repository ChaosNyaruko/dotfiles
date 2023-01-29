vim.cmd [[
let $FZF_DEFAULT_OPTS="--preview-window 'right:57%' --preview 'bat --style=numbers --line-range :300 {}' --bind ctrl-y:preview-up,ctrl-e:preview-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,shift-up:preview-top,shift-down:preview-bottom,alt-up:half-page-up,alt-down:half-page-down" 

" noremap <C-p> :Files<CR>
noremap <C-p> :FZF<CR>
noremap <leader>f :Rg<CR>
noremap sf :Files<CR>
let g:fzf_layout = { 'down': '40%' }

" borrowed from https://github.com/junegunn/fzf.vim/issues/837
 command! -bang -nargs=* PRg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'dir': expand('%:p:h')}, <bang>0)

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)

" command! -bang -nargs=* PRg
"  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': getenv('PWD')}), <bang>0)

command! -nargs=* -complete=dir -bang PFZF call fzf#run(fzf#wrap('FZF', fzf#vim#with_preview({'dir': getenv('PWD')}), <bang>0))
]]

vim.g.fzf_loaded = true
