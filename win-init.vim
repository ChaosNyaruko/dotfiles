set nocompatible
set nu
set rnu
set hlsearch
set incsearch
set ignorecase
set smartcase
set mouse=a
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
set noshowmode
set wildmenu
set wildmode=list:longest,full

set noswapfile
set nobackup
set nowritebackup

set hidden
set history=2000

if has('clipboard')
	if has('unnamedplus')  " When possible use + register for copy-paste
	    set clipboard=unnamed,unnamedplus
	else         " On mac and Windows, use * register for copy-paste
	    set clipboard=unnamed
	endif
endif

if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    " set statusline+=%{fugitive#statusline()} " Git Hotness
endif

call plug#begin(stdpath('data') . '\plugged')

Plug 'fatih/vim-go', {'tag': '*'}
Plug 'tpope/vim-commentary'
Plug 'easymotion/vim-easymotion'
" Plug 'rakr/vim-one'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
Plug 'tpope/vim-fugitive' 
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
"if has('vim')
"    Plug 'ycm-core/YouCompleteMe'
"elseif has('nvim')
"    " Use release branch (recommend)
"    Plug 'neoclide/coc.nvim', {'branch': 'release'}
"    "
"    " " Or build from source code by using yarn: https://yarnpkg.com
"    Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install  --frozen-lockfile'}
"endif

call plug#end()
set nolist
set listchars=space:\ ,tab:>\ 
set backspace=indent,eol,start
let mapleader=' '
" colorscheme one
" let g:airline#extensions#tabline#enabled = 1

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

let g:lightline = {
  \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
  \             [ 'readonly', 'filename', 'modified', 'pwd' ] ]
  \ },
  \ 'component': {
      \   'pwd': '%{getcwd()}'
  \ },
  \ }

colorscheme default


" Key Mappings
" noremap <C-p> :Files<CR>
" noremap <leader>f :Rg<CR>
" inoremap <C-f> <Right>
" inoremap <C-b> <Left>
" Using telescope instead of fzf on Windows
nnoremap <C-p> <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>f <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>b <cmd>lua require('telescope.builtin').buffers()<cr>
" nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" vim-go navi mappings
autocmd FileType go nnoremap <buffer> gr :GoReferrers<CR>
autocmd FileType go nnoremap <buffer> gi :GoImplements<CR>
autocmd FileType go nnoremap <buffer> goc :GoCallers<CR>
" autocmd FileType go inoremap <buffer> <C-i> .<C-x><C-o>

" vim-go settings
let g:go_doc_popup_window = 1

" just something interesting saw in coding videos
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
autocmd FileType qf :set norelativenumber

set background=dark
function! ResCur()
    if line("'\"") <= line("$")
        silent! normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END
" Always switch to the current file directory
" autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

" autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

" for fzf preview-window
" see https://github.com/junegunn/fzf.vim/issues/358
" let $FZF_DEFAULT_OPTS="--preview-window 'right:57%' --preview 'bat --style=numbers --line-range :300 {}' --bind ctrl-y:preview-up,ctrl-e:preview-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,shift-up:preview-top,shift-down:preview-bottom,alt-up:half-page-up,alt-down:half-page-down" 
"
lua << EOF
require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
        n = {
            ['q'] = "close"
        }
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}
EOF
