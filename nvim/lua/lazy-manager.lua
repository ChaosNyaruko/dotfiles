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
    {
        'neovim/nvim-lspconfig',
        ft  = {"go", "lua", "python", "c", "cpp", "rust"},
        config = function ()
            require("settings.lspconfig")
            require("settings.fzf")
        end
    },
    {
        'williamboman/mason.nvim',
        lazy = true,
        cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
        config = function ()
            require("settings.mason")
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
        event = "VimEnter",
        enabled = true,
        config = function ()
            require("settings.lualine")
        end
    }, -- TODO: when this plugin is used, a strange bug happen, see lualine_bug.lua, and codium_status may be the source
    {'itchyny/lightline.vim', enabled = false},
    {
        'hrsh7th/nvim-cmp',
        event = {"InsertEnter", "CmdlineEnter"},
        config = function ()
            require("settings.nvim-cmp")
        end,
        dependencies = {
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'hrsh7th/cmp-cmdline'},
            {'hrsh7th/cmp-nvim-lsp-signature-help'},
            {'quangnguyen30192/cmp-nvim-ultisnips'},
        }
    },
    {'SirVer/ultisnips', lazy = false},
    {'onsails/lspkind.nvim', event = "VeryLazy", lazy = true},
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = true,
        cmd = {"TSInstallInfo", "TSUpdate"},
        build = ':TSUpdate',
        config = function ()
            require("settings.treesitter")
        end
    },
    { 'nvim-treesitter/playground',      enabled = false, event = "VeryLazy" },
    {'nvim-treesitter/nvim-treesitter-context', event = "VeryLazy"},
    {'nvim-lua/plenary.nvim', event = "VeryLazy"},
    {
        'nvim-telescope/telescope.nvim',
        keys = { {"<C-p>", mode = "n"} },
        config = function ()
            require("settings.telescope")
        end,
        dependencies = {
            {'nvim-telescope/telescope-file-browser.nvim'},
            {'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'},
        }
    },
    {"gfanto/fzf-lsp.nvim",
        lazy = true,
    },
    { 'fatih/vim-go', lazy = true, ft = {"go", "gomod"}, enabled = false},
    {'tpope/vim-commentary', event = "VeryLazy"},
    {'preservim/vim-markdown', ft = "markdown", event = "VeryLazy"},
    {'godlygeek/tabular', event = "VeryLazy"},
    {'christoomey/vim-tmux-navigator', enable = false, event = "VeryLazy"},
    { 'junegunn/fzf',                 build = ":call fzf#install()" , event = "VeryLazy"},
    {'junegunn/fzf.vim', event = "VeryLazy"},
    {'tpope/vim-fugitive', event = "VeryLazy"},
    {'tpope/vim-surround', event = "VeryLazy"},
    {'mbbill/undotree', event = "VeryLazy"},
    {'gcmt/wildfire.vim', event = "VeryLazy"},
    'NLKNguyen/papercolor-theme',
    {'preservim/nerdtree', enabled = false},
    { 'iamcco/markdown-preview.nvim', ft = "markdown", build = function() vim.fn["mkdp#util#install"]() end , event = "VeryLazy"},
    {  'vim-autoformat/vim-autoformat',
        event = "VeryLazy",
    },
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
    },
    {
        'Exafunction/codeium.vim',
        enabled = false,
        event = "VeryLazy",
        config = function()
            -- Change '<C-g>' here to any keycode you like.
            vim.keymap.set('i', '<tab>', function() return vim.fn['codeium#Accept']() end, { expr = true })
            -- vim.keymap.set('i', '<C-;>', function() return vim.fn['codeium#CycleCompletions'](1) end,
            --     { expr = true, desc = "codedium#CycleCompletions" })
            -- vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions']( -1) end, { expr = true })
            vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
            vim.g.codeium_enabled = true
            vim.g.codeium_filetypes = { python = true, go = false }
        end
    },
{
    'goolord/alpha-nvim',
    enabled = false,
    config = function ()
        require'alpha'.setup(require'alpha.themes.startify'.config)
    end,
},
    {"itchyny/dictionary.vim", enable = false},
    {"ChaosNyaruko/ondict", event = "VeryLazy"}
})
-- require("settings.mason")
-- require("settings.fzf")
-- require("settings.lspconfig")
-- require("settings.nvim-cmp")
-- require("settings.lualine")
-- require("settings.treesitter")
-- require("settings.telescope")
