set statusline=%f
set statusline=%f\ -\ FileType:\ %y
set statusline=%f         " Path to the file
set statusline+=\ -\      " Separator
set statusline+=FileType: " Label
set statusline+=%y        " Filetype of the file
set statusline=%l    " Current line
set statusline+=/    " Separator
set statusline+=%L   " Total lines
set statusline=[%4l]
set statusline=Current:\ %4l\ Total:\ %4L
set statusline=Current:\ %-4l\ Total:\ %-4L
set statusline=%04l
set statusline=%F
set statusline=%.20F " will be truncated if necessary
" :h statusline
" %-0{minwid}.{maxwid}{item}
"
set statusline=%f         " Path to the file
set statusline+=%=        " Switch to the right side
set statusline+=%l        " Current line
set statusline+=/         " Separator
set statusline+=%L        " Total lines
