augroup mine
autocmd!
autocmd FileType vim,python echo expand('<amatch>') . " FILE"
autocmd User My echo expand('<amatch>') . " MY"
augroup END
doautocmd mine FileType python,vim "no effect
doautocmd mine FileType go "noeffect
doautocmd mine FileType python "works
doautocmd mine FileType vim "works
finish
let s:compile_name = "__PLAY__"
let s:compile_buffer = bufnr(s:compile_name, 1)
" echom "compile buffer " . bufnr(s:compile_buffer)
call setbufvar(s:compile_buffer, "&buflisted", v:true)
call setbufvar(s:compile_buffer, "&buftype", "nofile")
call bufload(s:compile_buffer)
call setbufline(s:compile_buffer, "$", "haha")

