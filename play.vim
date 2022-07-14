function! s:shit(dir)
    echo a:dir
endfunction
command! -nargs=* -complete=dir -bang Shit call s:shit(<q-args>)
