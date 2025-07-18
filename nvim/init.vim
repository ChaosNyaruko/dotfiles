" This file is supposed to be used for NeoVim, typically put in ~/.config/nvim
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath=&runtimepath
" source ~/.vimrc
" set guicursor=i:block
filetype plugin indent on
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
set showmode
set fileencodings=utf-8,gbk,gb18030,gb2312,big5
set wildmenu
set wildmode=list:longest,full " basically [:] means [&&]  [,] means [then]
" set wildoptions=pum,tagfile "nvim's default settings
set showtabline=1
set laststatus=3
set novisualbell
set noswapfile
set nobackup
set nowritebackup
set hidden
set history=2000
set splitright
let mapleader=" "
set nolist
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
set textwidth=0
if $LC_TERMINAL == "iTerm2" "ITERM_PROFILE will not be passed to a 'ssh' server.
    set bg=light
endif


" Common mappings
vnoremap < <gv
vnoremap > >gv
vnoremap <leader>f y/<c-r>"

tnoremap <esc> <c-\><c-n>

" norelativenumber for quickfix
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
autocmd FileType qf :set norelativenumber

set undodir=~/.local/state/nvim/undo
set undofile
"
" Share clipboard if possible
if has('clipboard') 
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif

if exists("g:vscode") 
    finish
endif

" A function for default basic emacs/bash-like moving in insert mode
" might be useful when using Chinese input method
function! ToggleEmacsMapping(prompt)
    " vim has defined ctrl-u alt-b for similar functionality
    if g:emacs_mapping==1
        if (a:prompt)
            echo "emacs_mapping is on, turning it off"
        endif
        iunmap <C-f>
        iunmap <C-b>
        iunmap <C-n>
        iunmap <C-p>
        iunmap <C-a>
        iunmap <C-e>
        iunmap <C-k>
        iunmap <A-f>
        let g:emacs_mapping=0
    else
        " TODO: using magarg to save/restore original mapping
        " https://vi.stackexchange.com/questions/7734/how-to-save-and-restore-a-mapping
        if (a:prompt)
            echo "emacs_mapping is off, turning it on"
        endif
        inoremap <C-f> <Right>
        inoremap <C-b> <Left>
        inoremap <C-n> <cmd>execute "normal! g\<lt>Down>"<cr>
        inoremap <C-p> <cmd>execute "normal! g\<lt>Up>"<cr>
        inoremap <C-a> <Home>
        inoremap <C-e> <End>
        inoremap <C-k> <C-o>D
        inoremap <A-f> <esc>lwi
        inoremap <A-b> <esc>bi
        let g:emacs_mapping=1
    endif
endfunction
let g:emacs_mapping=0
call ToggleEmacsMapping(v:false)
command! -nargs=0 ToggleEmacs call ToggleEmacsMapping(v:true) "}}}

" Auto jump back to the last position when opened {{{
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

" FZF settings.
" for fzf preview-window
" see https://github.com/junegunn/fzf.vim/issues/358
" let $FZF_DEFAULT_OPTS="--preview-window 'right:57%' --preview 'bat --style=numbers --line-range :300 {}' --bind ctrl-y:preview-up,ctrl-e:preview-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,shift-up:preview-top,shift-down:preview-bottom,alt-up:half-page-up,alt-down:half-page-down" 
let $FZF_DEFAULT_OPTS="--preview-window 'right:57%' --bind ctrl-y:preview-up,ctrl-e:preview-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,shift-up:preview-top,shift-down:preview-bottom,alt-up:half-page-up,alt-down:half-page-down" 
let $FZF_DEFAULT_COMMAND="fd --hidden --type f" 
" set autochdir
" noremap <C-p> :Files<CR>
nnoremap <leader>f :Rg<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap sf :LFiles<CR>
let g:fzf_layout = { 'down': '40%' }
command! -bang -nargs=? -complete=dir LFiles
    \ call fzf#vim#files(expand('%:p:h'), fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}, <bang>0))

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}, <bang>0))

command! -bang -nargs=* PRg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': getenv('PWD')}), <bang>0)

command! -nargs=* -complete=dir -bang PFZF call fzf#run(fzf#wrap('FZF', fzf#vim#with_preview({'dir': getenv('PWD')}), <bang>0))
nnoremap <C-p> :PFZF<CR>

function! s:onlyemoji(emoji_with_comments)
    return (split(join(a:emoji_with_comments), ' '))[0]
endfunction

inoremap <expr> <c-x><c-k> fzf#vim#complete({
            \ 'source': 'cat ~/.local/share/larbs/chars/emoji ~/.local/share/larbs/chars/font-awesome',
            \ 'reducer': function('<sid>onlyemoji'),
            \ 'right':    40
            \ })


" vim-go settings
" autocmd FileType go nnoremap <buffer> gr :GoReferrers<CR>
" autocmd FileType go nnoremap <buffer> gi :GoImplements<CR>
" autocmd FileType go nnoremap <buffer> goc :GoCallers<CR>
" au filetype go inoremap <buffer> . .<C-x><C-o>
" let g:go_list_type="quickfix"
" let g:go_doc_popup_window = 1

" markdown-preview config
" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" for path with space
" valid: `/path/with\ space/xxx`
" invalid: `/path/with\\ space/xxx`
" default: ''
let g:mkdp_browser = ''

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
" disable_filename: if disable filename header for preview page, default: 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0,
    \ 'toc': {}
    \ }

" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
" let g:mkdp_markdown_css = expand('~/dotfiles/github-markdown.css')

" use a custom highlight style must absolute path
" like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_highlight_css = ''

" use a custom port to start server or empty for random
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'

" recognized filetypes
" these filetypes will have MarkdownPreview... commands
let g:mkdp_filetypes = ['markdown']

" set default theme (dark or light)
" By default the theme is define according to the preferences of the system
let g:mkdp_theme = 'light'

augroup MarkDown
    autocmd!
    autocmd FileType markdown nnoremap <buffer> <F5> :MarkdownPreview<CR>
augroup END

" grep/make integration related stuff
" from http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
" jonhoo's config
if executable('ag')
        set grepprg=ag\ --nogroup\ --nocolor
endif
if executable('rg')
    " set grepprg=rg\ --no-heading\ --vimgrep\ $*\ $PWD
    set grepprg=rg\ --no-heading\ --vimgrep\ $* 
    set grepformat=%f:%l:%c:%m
endif

set colorcolumn=120
set signcolumn=yes
au Filetype cpp source ~/.config/nvim/scripts/spacetab.vim
au Filetype cpp setl colorcolumn=100
au Filetype go setl colorcolumn=120
" Highlight yank
au TextYankPost *  lua vim.highlight.on_yank() 

 " Leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste

" Prevent accidental writes to buffers that shouldn't be edited
autocmd BufRead *.orig set readonly
autocmd BufRead *.pacnew set readonly

" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-l>"
let g:UltiSnipsJumpBackwardTrigger="<c-h>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" set Meta based shortcuts
inoremap <M-s> <cmd>update<cr>
noremap <M-s> <cmd>update<cr>

nnoremap gV `[v`]
" ergonomic line operations
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
" easy operations for quickfix window
nnoremap ++ <cmd>cnext<cr>
nnoremap __ <cmd>cprevious<cr>

" vim_markdwon settings
let g:vim_markdown_folding_disabled = 1
" let g:vim_markdown_conceal = 0 " see 'conceallevel' for more 
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_json_frontmatter = 1
let g:vim_markdown_strikethrough = 1

" misc
nnoremap <leader>jq <cmd>%!jq .<cr>
let s:match_highlights = ["ErrorMsg", "StatusLine", "DiffChange", "DiffAdd", "DiffText", "DiffDelete", "SpellRare"]
let s:mh_index = 0
function MyMatch(bang, mode) abort
    " execute "normal" "*"
    " return
    if a:mode == "clear"
        echom "all matches cleared"
        call clearmatches()
        return
    endif
    if a:mode == "cword"
        let pattern = ""
    else
        let pattern = input("add a match:")
    endif
    if pattern == ""
        let pattern = expand("<cword>")
    endif
    if a:bang 
        let pattern = '\<' . pattern . '\>'
    endif
    echo printf("\nmatching %s", pattern)
    " redraw
    call feedkeys("\<CR>")
    let @/ = pattern
    call matchadd(s:match_highlights[s:mh_index], pattern)
    let s:mh_index = (s:mh_index + 1) % len(s:match_highlights)
endfunction

command! -nargs=? -bang Match call MyMatch(<bang>0, <q-args>)
nnoremap <M-*> <Cmd>Match clear<CR>
nnoremap <M-8> <Cmd>Match! cword<CR>
nnoremap <M-9> <Cmd>Match cword<CR>

inoremap <M-CR> <cmd>normal! $o <cr>

autocmd FileType markdown setl spell | setl spelllang+=cjk

set noshowmode
" match ErrorMsg '\%>80v.\+'
" :h /\%v
" lone line detection copied from https://vim.fandom.com/wiki/Highlight_long_lines
nnoremap <silent> <Leader>l
      \ :if exists('w:long_line_match') <Bar>
      \   silent! call matchdelete(w:long_line_match) <Bar>
      \   unlet w:long_line_match <Bar>
      \ elseif &textwidth > 0 <Bar>
      \   let w:long_line_match = matchadd('ErrorMsg', '\%>'.&tw.'v.\+', -1) <Bar>
      \ else <Bar>
      \   let w:long_line_match = matchadd('ErrorMsg', '\%>120v.\+', -1) <Bar>
      \ endif<CR>

" nnoremap cd :lcd %:p:h
nnoremap <C-w>n :call utils#Newscratch()<cr>

set inccommand=split
" -- open new file adjacent to current file
" vim.keymap.set('n', '<leader>o', ':e <C-R>=expand("%:p:h") . "/" <cr>')
nnoremap <Leader>o :e <C-R>=expand("%:p:h") . "/"<cr>
lua <<EOF
-- require("plugins")
require("lazy-manager")
-- vim.api.nvim_set_keymap('i', '<c-n>', '<cmd>normal! g<Down><cr>', {noremap = true})
-- vim.api.nvim_set_keymap('i', '<c-p>', '<cmd>normal! g<Up><cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>d', ':lua require("ondict").query()<cr>', {noremap = true})
vim.api.nvim_set_keymap('v', '<leader>d', '<cmd>lua require("ondict").query()<cr>', {noremap = true}) -- it must be <cmd>, not :, otherwise the "visual" mode state will be lost.
EOF
" colorscheme PaperColor
" nnoremap f /\%<c-r>=line('.')<cr>l

set exrc
" Plug 'andymass/vim-matchup' for more comprehensive one
set matchpairs+=<:>
nnoremap * *``
nnoremap # #``

augroup MyObsidian
    au! BufRead,BufNewFile **/obsidian-vault/** 
                \ nnoremap <buffer> <F6> <cmd>-1r ./templates/t1.md<cr> |
                \ inoremap <buffer> <F6> <cmd>-1r ./templates/t1.md<cr>
                \ inoremap <buffer> <F6> <cmd>-1r ./templates/t1.md<cr> |
                \ nnoremap <F7> :e daily/<C-R>=strftime("%Y-%m-%d") .. '.md'<cr><cr>
augroup END
" let g:copilot_proxy = 'http://localhost:11435'
" let g:copilot_proxy_strict_ssl = v:false
"
cnoremap vt /\v(_test)@<!\.go

nnoremap \t <cmd>call append(line("."), strftime("%F", localtime()))<cr>
