" inoremap jk <ESC>
" inoremap  <expr> h Ahahaha()

echo ">^.^<"
echom "---->^.^<----"
function! s:Ahahaha()
  return 'ahahaha'
endfunction

function! s:Hello()
    echo "helloworld"
endfunction
set noshiftround
set showmatch
set matchtime=5

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

inoremap <c-u> <esc>viwUea
" nnoremap <c-u> <esc>viwU
iunmap <c-u>
vnoremap <leader><leader>( <esc>`<i(<esc>`>la)<esc>l
set timeoutlen?

" nnoremap jk :call <SID>Hello()<cr>

scriptencoding utf-8
" :h i_CTRL-V
"
iabbrev mian main
" :set iskeyword?
" :h isfname
autocmd BufNewFile *.txt :write

autocmd BufWritePre,BufRead *.html :normal gg=G
autocmd BufWritePre,BufRead *.html setlocal nowrap

" :help local-options
" :help setlocal
" :help map-local
autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
autocmd FileType python     nnoremap <buffer> <localleader>c I#<esc>
autocmd FileType python    setlocal list 

" :help autocmd-events

iabbrev <buffer> --- &mdash;
autocmd FileType python :iabbrev <buffer> iff if:<left>
autocmd FileType javascript :iabbrev <buffer> iff if ()<left>

" snippet
autocmd FileType c++ :iabbrev <buffer> re return;

augroup testgroup
    autocmd BufWrite * :echom "Dogs"
augroup END

augroup testgroup
    " autocmd!
    autocmd BufWrite * :echom "Cats"
augroup END

augroup filetype_html
    autocmd!
    autocmd FileType html nnoremap <buffer> <localleader>f Vatzf
augroup END
" :h autocmd-groups

onoremap in( :<c-u>normal! f(vi(<cr>
" :h omap-info
"
:normal! ?^==\+$<cr>:nohlsearch<cr>kvg_
" :h pattern-overview
" :h normal
" :h execute
" :h expr-quote
