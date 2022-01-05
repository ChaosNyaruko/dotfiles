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
inoremap <c-u> <esc>viwUea
" nnoremap <c-u> <esc>viwU
iunmap <c-u>
vnoremap <leader><leader>( <esc>`<i(<esc>`>la)<esc>l
set timeoutlen?

" nnoremap jk :call <SID>Hello()<cr>

scriptencoding utf-8
" :h i_CTRL-V


