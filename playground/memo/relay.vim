if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,latin1
endif

syntax on
colorscheme desert
"execute pathogen#infect()
" set the runtime path to include Vundle and initialize
"set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin()
" let Vundle manage Vundle, required
"Plugin 'gmarik/Vundle.vim'
"Plugin 'fatih/vim-go'
"Plugin 'Valloric/YouCompleteMe'
"Plugin 'mileszs/ack.vim'
"call vundle#end()            " required
"filetype plugin indent on    " required
set tabstop=4
set expandtab
set softtabstop=4  
set shiftwidth=4 
filetype plugin indent off
set noautoindent
set nosmartindent
set nocindent
set nu
set paste
autocmd FileType python setlocal completeopt-=preview

filetype plugin indent on
if &term=="xterm"
     set t_Co=8
     set t_Sb=^[[4%dm
     set t_Sf=^[[3%dm
endif
cs add $CSCOPE_DB
if has("cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif



"for omnicomplete"

""set nocp
""filetype plugin on
""map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"set completeopt=menu"
""set cindent

""function ClosePair(char)
    ""if getline('.')[col('.') - 1] == a:char
    ""  return "\<Right>"
    ""else
    ""  return a:char
    ""endif
""endf

set laststatus=2
highlight StatusLine cterm=bold ctermfg=yellow ctermbg=blue

function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "g")
    return curdir
endfunction

set statusline=[%n]\ %f%m%r%h\ \|\ \ pwd:\ %{CurDir()}\ \ \|%=\|

set synmaxcol=200
