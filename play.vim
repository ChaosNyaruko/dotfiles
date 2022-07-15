function! s:shit(dir)
    echo a:dir
endfunction
command! -nargs=* -complete=dir -bang Shit call s:shit(<q-args>)

 let winid = popup_create('hello', {})
let bufnr = winbufnr(winid)
call setbufline(bufnr, 2, 'second line')
echo winid bufnr
popup_hide(bufnr) "wrong usage
