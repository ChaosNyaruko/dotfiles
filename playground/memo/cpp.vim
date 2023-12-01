" https://idie.ru/posts/vim-modern-cpp/
 highlight ExtraWhitespace ctermbg=red guibg=red
 match ExtraWhitespace /\s\+$/
 au BufWinEnter * match ExtraWhitespace /\s\+$/
 au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
 au InsertLeave * match ExtraWhitespace /\s\+$/
 au BufWinLeave * call clearmatches()
 " Remove all trailing whitespaces
 nnoremap <silent> <leader>rs :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s<Bar> :nohl <Bar> :unlet _s <CR>

