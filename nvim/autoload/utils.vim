" Get all lines in the buffer as a a list.
function! utils#GetLines()
    let buf = getline(1, '$')
    if &encoding != 'utf-8'
        let buf = map(buf, 'iconv(v:val, &encoding, "utf-8")')
    endif
    if &l:fileformat == 'dos'
    " XXX: line2byte() depend on 'fileformat' option.
    " so if fileformat is 'dos', 'buf' must include '\r'.
        let buf = map(buf, 'v:val."\r"')
     endif

     return buf
endfunction

function! utils#SaveAndSource()
    update
    echo "source " .. expand("%") | source %
endfunction

function! utils#Newscratch()
    execute 'tabnew '
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
endfunction

" function! SynStack()
"   if !exists("*synstack")
"     return
"   endif
"   echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "fg")')
" endfunc

" function! SynGroup()
"     let l:s = synID(line('.'), col('.'), 1)
"     echo synIDattr(l:s, 'fg') . ' -> ' . synIDattr(synIDtrans(l:s), 'fg')
" endfun

