" nnoremap <leader>g :grep -R '<cWORD>' .<cr>
" nnoremap <leader>g :execute "grep -R '<cWORD>' ."<cr>
" . shellescape(expand("<cWORD>")) . " ."
" shellescape("<cWORD>") . " ."<cr>
" nnoremap <leader>g :silent execute "grep -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>

nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
    let saved_unnamed_register = @@
    echom a:type
    if a:type ==# 'v'
        execute "normal! `<v`>y"
    elseif a:type ==# 'char'
        execute "normal! `[y`]"
    else 
        return
    endif
    " echom shellescape(@@)
    " use grep! instead of plain grep to not go to the first result automatically
    silent execute "grep! -R ".shellescape(@@)." ."
    copen

    let @@ = saved_unnamed_register
endfunction


