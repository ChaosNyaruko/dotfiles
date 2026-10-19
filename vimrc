set nocompatible
filetype plugin indent on
syntax on
set nu
set rnu
set shortmess+=c
set shortmess-=S
set hls

let g:ywvim_ims=[
            \['wb', '五笔', 'wubi.ywvim'],
            \['py', '拼音', 'pinyin.ywvim'],
            \]

let g:ywvim_py = { 'helpim':'wb', 'gb':0 }

let g:ywvim_zhpunc = 1
let g:ywvim_listmax = 5
let g:ywvim_esc_autoff = 1
let g:ywvim_autoinput = 0
let g:ywvim_intelligent_punc=1
let g:ywvim_circlecandidates = 1
let g:ywvim_helpim_on = 0
let g:ywvim_matchexact = 0
let g:ywvim_chinesecode = 1
let g:ywvim_gb = 0
let g:ywvim_preconv = 'g2b'
let g:ywvim_conv = ''
let g:ywvim_lockb = 1
