if !exists("g:potion_command")
    let g:potion_command = "potion"
endif

nnoremap <buffer> <localleader>r
            \ :call potion#running#PotionCompileAndRunFile()<cr>

nnoremap <buffer> <localleader>b
            \ :call potion#running#PotionShowBytecode()<cr>
" function! PotionCompileAndRunFile()
"     silent !clear
"     execute "!" . g:potion_command . " " . bufname("%")
" endfunction

" nnoremap <buffer> <localleader>r :call PotionCompileAndRunFile()<cr>

" a bytecode displayer
" nnoremap <buffer> <localleader>b :call PotionShowBytecode()<cr>
" function! PotionShowBytecode()
"     " Get the bytecode.
"     let bytecode = system(g:potion_command . " -c -V " . bufname("%") . " 2>&1")

"     " Open a new split and set it up.
"     vsplit __Potion_Bytecode__
"     normal! ggdG
"     setlocal filetype=potionbytecode
"     setlocal buftype=nofile

"     " Insert the bytecode.
"     call append(0, split(bytecode, '\v\n'))
" endfunction

