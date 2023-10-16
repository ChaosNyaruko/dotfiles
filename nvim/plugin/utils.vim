augroup myutils
    autocmd!
    autocmd Filetype vim,lua nnoremap <buffer> <F5> :call utils#SaveAndSource()<CR>
augroup end

function Newscratch()
    execute 'tabnew '
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
endfunction
