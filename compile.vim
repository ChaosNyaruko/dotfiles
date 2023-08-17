let s:compile_name = "__Compile__"
let s:compile_buffer = -1
" :h file-pattern
if bufexists(s:compile_name) 
    " echo bufwinnr(s:compile_name)
    let compile_window  = bufwinnr(s:compile_name)
    if compile_window == -1
        execute 'buffer ' . s:compile_name
        let s:compile_name = bufname()
        let s:compile_buffer = bufnr()
        echo s:compile_buffer
    else
        execute compile_window."wincmd w"
    endif
    " echo compile_window
    " echo bufname(s:compile_name)
else
    vnew
    set buftype=nofile
    set buflisted
    " set readonly
    file __Compile__
    let s:compile_buffer = bufnr()
    echo s:compile_buffer
endif

" echo s:compile_buffer
execute "%d_"
" execute "r!./build.sh"

" backup users errorformat, will be restored once we are finished
" refer to vim-go implementation
let old_errorformat = &errorformat
let s:errformat = "%f:%l:%c:\ %m,%f:%l:%c\ %#%m"
let s:out = call("system", ["./build.sh"])
let s:items = split(s:out, "\n")
" echo s:items
call setbufline(s:compile_name, "$", s:items)
" call setqflist(s:items, 'r')
cgetexpr s:items
call setqflist([], 'a', {"title": "./build.sh"}) " this seems to not take effect?
copen
let &errorformat = old_errorformat
