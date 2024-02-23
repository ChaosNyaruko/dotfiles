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

local at_home = function()
    -- disable codeium at working because of security policy
    if os.getenv("HOME"):find("bill") then
        return true
    else
        return false
    end
end


local plugins = {
    -- {
    --     "rust-lang/rust.vim",
    --     ft = { "rust" },
    -- },
    {
        'neovim/nvim-lspconfig',
        ft     = { "html", "go", "lua", "python", "c", "cpp", "rust" },
        config = function()
            require("settings.lspconfig")
            require("settings.fzf")
        end
    },
    {
        'williamboman/mason.nvim',
        lazy = true,
        cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
        config = function()
            require("settings.mason")
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
        event = "VimEnter",
        enabled = true,
        config = function()
            require("settings.lualine")
        end
    }, -- TODO: when this plugin is used, a strange bug happen, see lualine_bug.lua, and codium_status may be the source
    { 'itchyny/lightline.vim', enabled = false },
    {
        'hrsh7th/nvim-cmp',
        event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            require("settings.nvim-cmp")
        end,
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-cmdline' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            { 'quangnguyen30192/cmp-nvim-ultisnips' },
        }
    },
    { 'SirVer/ultisnips',      lazy = false },
    { 'onsails/lspkind.nvim',  event = "VeryLazy", lazy = true },
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = true,
        cmd = { "TSInstallInfo", "TSUpdate" },
        build = ':TSUpdate',
        config = function()
            require("settings.treesitter")
        end
    },
    { 'nvim-treesitter/playground',              cmd = "TSPlaygroundToggle", enabled = true, event = "VeryLazy" },
    { 'nvim-treesitter/nvim-treesitter-context', event = "VeryLazy" },
    { 'nvim-lua/plenary.nvim',                   event = "VeryLazy" },
    {
        'nvim-telescope/telescope.nvim',
        keys = {
            { "<leader>F",  mode = { "n", "v" } },
            { "<leader>tf", mode = { "n" } },
            { "<leader>ws", mode = { "n" } },
            { "<leader>sf", mode = { "n" } },
        },
        config = function()
            require("settings.telescope")
        end,
        dependencies = {
            { 'nvim-telescope/telescope-file-browser.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim',  build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
        }
    },
    {
        "gfanto/fzf-lsp.nvim",
        lazy = true,
        enabled = false
    },
    { 'fatih/vim-go',           lazy = true,                   ft = { "go", "gomod" }, enabled = false },
    { 'tpope/vim-commentary',   event = "VeryLazy" },
    { 'preservim/vim-markdown', ft = "markdown",               event = "VeryLazy" },
    { 'godlygeek/tabular',      event = "VeryLazy" },
    -- { 'christoomey/vim-tmux-navigator', enable = false,                event = "VeryLazy" },
    { 'junegunn/fzf',           build = ":call fzf#install()", event = "VeryLazy" },
    { 'junegunn/fzf.vim',       event = "VeryLazy" },
    { 'tpope/vim-fugitive',     event = "VeryLazy" },
    { 'tpope/vim-surround',     event = "VeryLazy" },
    { 'mbbill/undotree',        event = "VeryLazy" },
    -- { 'gcmt/wildfire.vim',              event = "VeryLazy" },
    -- { 'NLKNguyen/papercolor-theme',
    --     init = function()
    --         vim.cmd.colorscheme "PaperColor"
    --     end,
    --     enable = false
    -- },
    {
        "catppuccin/nvim",
        config = function()
            require("catppuccin").setup({
                flavour = "latte", -- latte, frappe, macchiato, mocha
                background = { -- :h background
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = false, -- disables setting the background color.
                show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
                term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
                dim_inactive = {
                    enabled = false, -- dims the background color of inactive window
                    shade = "dark",
                    percentage = 0.15, -- percentage of the shade to apply to the inactive window
                },
                no_italic = false, -- Force no italic
                no_bold = false, -- Force no bold
                no_underline = false, -- Force no underline
                styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
                    comments = { "italic" }, -- Change the style of comments
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                },
                color_overrides = {},
                custom_highlights = {},
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    notify = false,
                    mini = {
                        enabled = true,
                        indentscope_color = "",
                    },
                    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
                },
            })

            -- setup must be called before loading
            vim.cmd.colorscheme "catppuccin"
        end
    },
    -- {
    --     "ronisbr/nano-theme.nvim",
    --     init = function()
    --         vim.o.background = "light" -- or "dark".
    --         vim.cmd.colorscheme "nano-theme"
    --     end
    -- },
    { 'preservim/nerdtree',           enabled = false },
    { 'iamcco/markdown-preview.nvim', ft = "markdown", build = function() vim.fn["mkdp#util#install"]() end, event = "VeryLazy" },
    -- { 'vim-autoformat/vim-autoformat',
    --     event = "VeryLazy",
    -- },
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
        "Dummy",
        url = "https://code.byted.org/zhanghaoyang.tomoko/dummy-coder.nvim",
        enabled = function()
            return false
            -- return not at_home()
        end,
        config = function()
            require("dummy-coder").setup {
                -- 是否在 command line area 打印过程信息
                -- Whether to print process information in the command line area
                print_info = false,
                enable = true,
                plugins = {
                    code_gen = {
                        enable = true,
                        max_context_range = 80,
                        max_suffix_range = 5,
                        treesitter = {
                            enable = true,
                            -- treesitter 从当前节点向上找寻 parent 的最大深度
                            -- 如果 treesitter 在从当前节点向上遍历时遇到的节点不在 consider_context_types 中
                            -- 便会继续向上遍历，直到超出 max_depth
                            -- The maximum depth of the parent from the current node upwards
                            -- If the treesitter encounters a node whose type wasn't in `consider_context_types`
                            -- Will continue to traverse upwards until the searching depth exceeds max_depth
                            max_depth = 10,
                            -- treesitter 会加入 context 考虑的上下文
                            -- treesitter node types that will be considered as context
                            consider_context_types = {
                                'declaration',
                                'comment',
                                'block',
                            },
                        },
                        -- vim 获得的 file_type 到 codeverse 支持的语言的映射
                        -- 没找到对应的文档，所以可能得自己尝试一下
                        -- Mapping of file_type obtained by vim to languages supported by codeverse
                        -- I didn't find the corresponding document about which languages
                        -- codevere supports so you may have to try it myself.
                        filetype_to_language = default_file_extention_to_language,
                        -- 哪些 filetype 下的代码片段需要被 CodeGen 插件处理
                        -- 默认为 filetype_to_language 中的 key
                        -- 设置会 覆盖 而不是 合并
                        -- 如果想要 "增加" 某个文件类型，建议配置 filetyoe_to_language
                        -- Which code snippets under filetype need to be processed by the CodeGen.
                        -- defaulting to the keys in filetype_to_language
                        -- Settings will be *overwritten* instead of merged.
                        -- If you want to "increase" a file type, it is recommended to configure filetyoe_to_language
                        enable_filetype = nil,
                    },
                },
                log = {
                    file = '', --filename you want to setup your log, if unset or '', dummycoder will initiate a default one
                    min_level = 'INFO', --TRACE, DEBUG, INFO, WARN, ERROR
                    auto_clear = false, -- if true, dummycoder will try to clean last time's log file at next start
                },
                cacheConfig = {
                    -- dir you want to place your login-related token
                    config_dir = default_cache_config_dir,
                },
                agent = {
                    timeout = {
                        login = default_request_timeout_mssec,
                        code_gen = default_request_timeout_mssec,
                        login_check = default_request_timeout_mssec,
                        get_jwt_token = default_request_timeout_mssec,
                        get_cas_session_cookie = default_request_timeout_mssec,
                    },
                },
                mappings = {
                    DummyCoderLogin = nil,
                    DummyCoderLog = nil,
                    DummyCoderTokenConfig = nil,
                    DummyCoderComplete = { n = '<C-t>', i = '<C-t>' },
                    DummyCoderAccept = { i = '<C-]>', n = '<C-]>' },
                    DummyCoderDisable = nil,
                    DummyCoderEnable = nil,
                    DummyCoderDisableBuffer = nil,
                    DummyCoderEnableBuffer = nil
                },
            }
        end
    },
    {
        'Exafunction/codeium.vim',
        enabled = at_home, event = "VeryLazy",
        init = function()
            vim.g.codeium_enabled = true
            vim.g.codeium_filetypes = { python = true, go = true, rust = false }
        end,
        config = function()
            -- Change '<C-g>' here to any keycode you like.
            vim.keymap.set('i', '<tab>', function() return vim.fn['codeium#Accept']() end, { expr = true })
            vim.keymap.set('i', '<C-;>', function() return vim.fn['codeium#CycleCompletions'](1) end,
                { expr = true, desc = "codedium#CycleCompletions" })
            vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions']( -1) end, { expr = true })
            vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
        end
    },
    {
        'goolord/alpha-nvim',
        enabled = false,
        config = function()
            require 'alpha'.setup(require 'alpha.themes.startify'.config)
        end,
    },
    { "itchyny/dictionary.vim", enable = false },
    {
        "ChaosNyaruko/ondict",
        event = "VeryLazy",
        build = function(plugin)
            require("ondict").install(plugin.dir)
        end,
        dev = false
    },
    {
        "loctvl842/breadcrumb.nvim",
        config = function()
            require("breadcrumb").init()
        end,
        enabled = false,
    },
    {
        'Bekaboo/dropbar.nvim',
        -- optional, but required for fuzzy finder support
        dependencies = {
            'nvim-telescope/telescope-fzf-native.nvim'
        },
        enabled = false,
    },
    {
        "tpope/vim-rsi",
        enabled = false,
    },
    {
        "nvim-lua/lsp_extensions.nvim",
        -- ft     = {"rust"},
        config = function()
            -- Enable type inlay hints
            vim.cmd [[autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }]]
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
            require("settings.treesitter")
        end
    }
}

local opts = {
    dev = {
        path = "~/github.com",
        pattern = {},
        fallback = false,
    }
}

require("lazy").setup(plugins, opts)
-- require("settings.mason")
-- require("settings.fzf")
-- require("settings.lspconfig")
-- require("settings.nvim-cmp")
-- require("settings.lualine")
-- require("settings.treesitter")
-- require("settings.telescope")
