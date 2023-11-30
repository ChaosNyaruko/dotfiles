set nocompatible

import default settings
" source $VIMRUNTIME/vimrc_example.vim
"
" " use 4 spaces instead of tab
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
"
" " While searching though a file incrementally highlight matching characters
" as you type.
set incsearch
"
" " Override the ignorecase option if searching for capital letters.
" " This will allow you to search specifically for capital letters.
set smartcase
"
" " Use highlighting when doing a search.
set hlsearch
"
" " when you press *, just highlight and stay still
nnoremap * :keepjumps normal! mi*`i<CR>
"
" " wrap lines
autocmd OptionSet * set wrap
"
" " highlight spaces at the end of line
highlight WhiteSpaceEOL ctermbg=darkgreen guibg=lightgreen
match WhiteSpaceEOL /\s$/
autocmd WinEnter * match WhiteSpaceEOL /\s$/
"
" " vim default leader key is \
" " press \p when you paste text from outside to keep indents,
" " and press it again to disable paste mode
nnoremap <Leader>p :set paste!<Cr>
"
" " press \r to avoid misoperation
" " and press again if you really need to do modification
nnoremap <Leader>r :set readonly!<Cr>
"
" " press ctrl-l to clean search highlight
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
"
" " after you paste something, press gb to select it in visual mode
" " so that you could format it or do something else
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

" file management
function! NetrwRemoveRecursive()
  if &filetype ==# 'netrw'
    cnoremap <buffer> <CR> rm -r<CR>
    normal mu
    normal mf
    try
      normal mx
    catch
      echo "Canceled"
    endtry

    cunmap <buffer> <CR>
  endif
endfunction

function! NetrwMapping()
    nmap <buffer> FF :call NetrwRemoveRecursive()<CR>
endfunction

augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END
