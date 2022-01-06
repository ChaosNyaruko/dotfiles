" nnoremap <leader>g :grep -R '<cWORD>' .<cr>
" nnoremap <leader>g :execute "grep -R '<cWORD>' ."<cr>
" . shellescape(expand("<cWORD>")) . " ."
" shellescape("<cWORD>") . " ."<cr>
nnoremap <leader>g :silent execute "grep -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>


