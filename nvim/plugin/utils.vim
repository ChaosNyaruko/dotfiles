augroup myutils
    autocmd!
    autocmd Filetype vim,lua nnoremap <buffer> <F5> :call utils#SaveAndSource()<CR>
augroup end

