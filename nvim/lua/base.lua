vim.cmd('autocmd!')

vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.mouse = 'a'
vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest,full'
-- vim.opt.wildoptions = 'pum'

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.laststatus = 2
vim.opt.showtabline = 1

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.visualbell = false

vim.opt.cmdheight = 1

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'nosplit'

vim.opt.hidden = true
vim.opt.history = 2000
vim.opt.splitright = true

vim.opt.list = false
vim.opt.listchars = { tab = "› ", trail = '•', extends = '#', nbsp = '.' }
vim.opt.backspace = { "indent", "eol", "start" }
vim.g.mapleader = " "

-- Undercurl, doesn't work on iTerm2
vim.cmd([[let &t_Cs = "\e[4:3m]"]])
vim.cmd([[let &t_Ce = "\e[4:0m]"]])

vim.api.nvim_create_autocmd('InsertEnter', { pattern = '*', command = "set norelativenumber" })
vim.api.nvim_create_autocmd('InsertLeave', { pattern = '*', command = "set relativenumber" })
vim.api.nvim_create_autocmd('FileType', { pattern = 'qf', command = "set norelativenumber" })

-- my simple statusline
vim.opt.shortmess:remove { 'S' }
vim.opt.statusline = '%<%f ' -- Filename
vim.opt.statusline:append '%w%h%m%r' -- Options
vim.opt.statusline:append ' [%{&ff}/%Y/%{&fileencoding?&fileencoding:&encoding}]' -- Filetype
-- vim.opt.statusline:append ' [%{getcwd()}]' -- Current dir
-- vim.opt.statusline:append ' %b 0x%B' -- :ascii
vim.opt.statusline:append '%=%-14.(%l,%c%V%) %p%%' -- Right aligned file nav info
vim.opt.statusline:append '%{fugitive#statusline()}' -- Git Hotness
