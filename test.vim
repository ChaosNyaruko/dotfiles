python << EOF
import vim
buf = vim.current.buffer
print(buf[:])
buf.append("its appended")
EOF
its appended

function! GetVimIndent_fix()
  let ind = GetVimIndentIntern()
  let prev = getline(prevnonblank(v:lnum - 1))
  if prev =~ '\s[{[]\s*$' && prev =~ '\s*\\'
    let ind -= shiftwidth()
  endif
  return ind
endfunction

setlocal indentexpr=GetVimIndent_fix()

