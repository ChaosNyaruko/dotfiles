echo systemlist("cat" . "<<< $" . "HOME")
finish
writefile(["testappend", "event.log", "a")
finish
lua <<EOF
local cnt=0
function cb()
    print("moved!", cnt)
    cnt = cnt+1
   -- pcall(vim.api.nvim_win_set_cursor, 0,  {1, 0})
end
 -- vim.api.nvim_win_set_cursor(0, {1, 1})
-- lua pcall(vim.api.nvim_win_set_cursor, 0,  {1, 2})
-- pcall(vim.api.nvim_win_set_cursor, 0,  {1, 3})
EOF
autocmd CursorMoved * lua cb() 
call cursor(1, 1)
finish
lua pcall(vim.api.nvim_win_set_cursor, 0,  {1, 3})
" echo append(1, "")
finish
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

function! s:get_char(...)
  let c = (a:0 == 0) ? getchar() : getchar(a:1)
  " If the character is a number, then it's not a special key
  if type(c) == 0
    let c = nr2char(c)
  endif
  return c
endfunction

let new_char = s:get_char()
echo new_char
