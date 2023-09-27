let s:compile_name = "__PLAY__"
let s:compile_buffer = bufnr(s:compile_name, 1)
" echom "compile buffer " . bufnr(s:compile_buffer)
call setbufvar(s:compile_buffer, "&buflisted", v:true)
call setbufvar(s:compile_buffer, "&buftype", "nofile")
call bufload(s:compile_buffer)
call setbufline(s:compile_buffer, "$", "haha")

