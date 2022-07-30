function! s:shit(dir)
    echo a:dir
endfunction
command! -nargs=* -complete=dir -bang Shit call s:shit(<q-args>)

let winid = popup_create('hello', {})
let bufnr = winbufnr(winid)
call setbufline(bufnr, 2, 'second line')
echo winid bufnr
" sleep 5
" call popup_close(winid)
"
call popup_clear()
function! SimpleEval()
    let l:in = input("Please in put a simple string", "your eval is:")
    redraw
    echo l:in
endfunction

