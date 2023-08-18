let s:compile_name = "__Compile__"
let s:compile_buffer = bufnr(s:compile_name, 1)
call setbufvar(s:compile_buffer, "&buflisted", v:true)
call setbufvar(s:compile_buffer, "&buftype", "nofile")
call bufload(s:compile_buffer)
" :h file-pattern
function! MyBuild(cmd)
    let l:cmd = "./build.sh"
    if a:cmd != ""
        let l:cmd = a:cmd
    endif

    " if bufexists(s:compile_name) 
    "     " echo bufwinnr(s:compile_name)
    "     let compile_window  = bufwinnr(s:compile_name)
    "     if compile_window == -1
    "         execute 'buffer ' . s:compile_name
    "         let s:compile_name = bufname()
    "         let s:compile_buffer = bufnr()
    "         " echo s:compile_buffer
    "     else
    "         execute compile_window."wincmd w"
    "     endif
    "     " echo compile_window
    "     " echo bufname(s:compile_name)
    " else
    "     vnew
    "     set buftype=nofile
    "     set buflisted
    "     " set readonly
    "     file __Compile__
    "     let s:compile_buffer = bufnr()
    "     " echo s:compile_buffer
    " endif

    " echo s:compile_buffer
    " execute "%d_"
    " execute "r!./build.sh"

    " backup users errorformat, will be restored once we are finished
    " refer to vim-go implementation
    " let old_errorformat = &errorformat
    " let s:errformat = "%f:%l:%c:\ %m,%f:%l:%c\ %#%m"
    echom "MyBuild [" . cmd . "] building..."
    let s:out = call("system", [cmd])
    echom "MyBuild [" . cmd . "] done!"
    let s:items = split(s:out, "\n")
    " echo s:items
    call setbufline(s:compile_buffer, "$", s:items)
    " call setqflist(s:items, 'r')
    if len(s:items) != 0
        cgetexpr s:items
        call setqflist([], 'a', {"title": "MyBuild"}) " this seems to not take effect?
        copen
    endif
    " let &errorformat = old_errorformat
endfunction

nnoremap <buffer> <F5> <Cmd>call MyBuild("")<Cr>
" TODO: 
" async call
" better default cmd
" mapping ways
