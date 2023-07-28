local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    'neovim/nvim-lspconfig', -- LSP
    'williamboman/mason.nvim',
    { 'nvim-lualine/lualine.nvim',       dependencies = { 'kyazdani42/nvim-web-devicons', lazy = true } },
    'hrsh7th/nvim-cmp',
    -- {
    --     "L3MON4D3/LuaSnip",
    --     -- follow latest release.
    --     version = "1.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    --     -- install jsregexp (optional!).
    --     build = "make install_jsregexp"
    -- },
    'SirVer/ultisnips',
    'onsails/lspkind.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'quangnguyen30192/cmp-nvim-ultisnips',
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { 'nvim-treesitter/playground',      enabled = false },
    'nvim-treesitter/nvim-treesitter-context',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
    "gfanto/fzf-lsp.nvim",
    { 'fatih/vim-go',                             enabled = true },
    'tpope/vim-commentary',
    'preservim/vim-markdown',
    'godlygeek/tabular',
    'christoomey/vim-tmux-navigator',
    { 'junegunn/fzf',                 build = ":call fzf#install()" },
    'junegunn/fzf.vim',
    'tpope/vim-fugitive',
    'tpope/vim-surround',
    'mbbill/undotree',
    'gcmt/wildfire.vim',
    'NLKNguyen/papercolor-theme',
    'preservim/nerdtree',
    { 'iamcco/markdown-preview.nvim', build = function() vim.fn["mkdp#util#install"]() end },
    { 'vim-autoformat/vim-autoformat' },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        enabled = false,
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            plugins = {
                marks = true, -- shows a list of your marks on ' and `
                registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
                -- the presets plugin, adds help for a bunch of default keybindings in Neovim
                -- No actual key bindings are created
                spelling = {
                    enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                    suggestions = 20, -- how many suggestions should be shown in the list?
                },
                presets = {
                    operators = true, -- adds help for operators like d, y, ...
                    motions = true, -- adds help for motions
                    text_objects = true, -- help for text objects triggered after entering an operator
                    windows = true, -- default bindings on <c-w>
                    nav = true, -- misc bindings to work with windows
                    z = true, -- bindings for folds, spelling and others prefixed with z
                    g = true, -- bindings for prefixed with g
                },
            },
            -- add operators that will trigger motion and text object completion
            -- to enable all native operators, set the preset / operators plugin above
            operators = { gc = "Comments" },
            key_labels = {
                -- override the label used to display some keys. It doesn't effect WK in any other way.
                -- For example:
                -- ["<space>"] = "SPC",
                -- ["<cr>"] = "RET",
                -- ["<tab>"] = "TAB",
            },
            motions = {
                count = true,
            },
            icons = {
                breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
                separator = "➜", -- symbol used between a key and it's label
                group = "+", -- symbol prepended to a group
            },
            popup_mappings = {
                scroll_down = "<c-d>", -- binding to scroll down inside the popup
                scroll_up = "<c-u>", -- binding to scroll up inside the popup
            },
            window = {
                border = "none", -- none, single, double, shadow
                position = "bottom", -- bottom, top
                margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
                padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
                winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
                zindex = 1000, -- positive value to position WhichKey above other floating windows.
            },
            layout = {
                height = { min = 4, max = 25 }, -- min and max height of the columns
                width = { min = 20, max = 50 }, -- min and max width of the columns
                spacing = 3, -- spacing between columns
                align = "left", -- align columns left, center or right
            },
            ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
            hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
            show_help = true, -- show a help message in the command line for using WhichKey
            show_keys = true, -- show the currently pressed key and its label as a message in the command line
            triggers = "auto", -- automatically setup triggers
            -- triggers = {"<leader>"} -- or specifiy a list manually
            -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
            triggers_nowait = {
                -- marks
                "`",
                "'",
                "g`",
                "g'",
                -- registers
                '"',
                "<c-r>",
                -- spelling
                "z=",
            },
            triggers_blacklist = {
                -- list of mode / prefixes that should never be hooked by WhichKey
                -- this is mostly relevant for keymaps that start with a native binding
                i = { "j", "k" },
                v = { "j", "k" },
            },
            -- disable the WhichKey popup for certain buf types and file types.
            -- Disabled by default for Telescope
            disable = {
                buftypes = {},
                filetypes = {},
            },
        }
    }
})
require("settings.mason")
require("settings.fzf")
require("settings.lspconfig")
require("settings.nvim-cmp")
require("settings.lualine")
require("settings.treesitter")
require("settings.telescope")