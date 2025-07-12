-- https://github.com/neovim/neovim/discussions/29350
vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
}
if vim.env.TMUX ~= nil then
    local copy = { 'tmux', 'load-buffer', '-w', '-' }
    local paste = { 'bash', '-c', 'tmux refresh-client -l && sleep 0.05 && tmux save-buffer -' }
    vim.g.clipboard = {
        name = 'tmux',
        copy = {
            ['+'] = copy,
            ['*'] = copy,
        },
        paste = {
            ['+'] = paste,
            ['*'] = paste,
        },
        cache_enabled = 0,
    }
end

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


local function toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd [[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
    else
        vim.cmd [[setlocal ve=]]
        vim.api.nvim_buf_del_keymap(0, "n", "J")
        vim.api.nvim_buf_del_keymap(0, "n", "K")
        vim.api.nvim_buf_del_keymap(0, "n", "L")
        vim.api.nvim_buf_del_keymap(0, "n", "H")
        vim.api.nvim_buf_del_keymap(0, "v", "f")
        vim.b.venn_enabled = nil
    end
end

local plugins = {
    {
        "jbyuki/venn.nvim",
        config = function()
            -- toggle keymappings for venn using <leader>v
            vim.keymap.set('n', '<leader>vv', function()
                vim.notify("toggle venn"); toggle_venn()
            end, { buffer = true, noremap = true, desc = "toggle venn" })
        end
    },
    {
        "ej-shafran/compile-mode.nvim",
        -- you can just use the latest version:
        -- branch = "latest",
        -- or the most up-to-date updates:
        -- branch = "nightly",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- if you want to enable coloring of ANSI escape codes in
            -- compilation output, add:
            -- { "m00qek/baleia.nvim", tag = "v1.3.0" },
        },
        config = function()
            ---@type CompileModeOpts
            vim.g.compile_mode = {
                -- to add ANSI escape code support, add:
                -- baleia_setup = true,
                error_regexp_table = {
                },
                default_command = "rg --vimgrep ",
                debug = false,
            }
            vim.keymap.set("n", '<leader>cc', "<cmd>buffer! *compilation*<cr>",
                { buffer = false, desc = "quickly open compilation buffer" })
            vim.keymap.set("n", '<F5>', "<cmd>Compile<cr>",
                { buffer = false, desc = "quickly launch Compile" })
        end
    },
    {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
            -- add options here
            -- or leave it empty to use the default settings
        },
        keys = {
            -- suggested keymap
            { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
        },
    },
    {
        enabled = true,
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        keys = {
            { "<leader>ss", function() Snacks.picker.lsp_symbols() end },
            { "<leader>sk", function() Snacks.image.hover() end },
        },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            bigfile = { enabled = true },
            dashboard = { enabled = false },
            explorer = { enabled = false },
            indent = { enabled = false },
            input = { enabled = false },
            picker = { enabled = false },
            notifier = { enabled = false },
            quickfile = { enabled = false },
            scope = { enabled = false },
            scroll = { enabled = false },
            statuscolumn = { enabled = false },
            words = { enabled = false },
            styles = {
                snacks_image = {
                    relative = "editor",
                    col = -1,
                    row = 1,
                },
            },
            image =
            ---@class snacks.image.Config
            ---@field enabled? boolean enable image viewer
            ---@field wo? vim.wo|{} options for windows showing the image
            ---@field bo? vim.bo|{} options for the image buffer
            ---@field formats? string[]
            --- Resolves a reference to an image with src in a file (currently markdown only).
            --- Return the absolute path or url to the image.
            --- When `nil`, the path is resolved relative to the file.
            ---@field resolve? fun(file: string, src: string): string?
            ---@field convert? snacks.image.convert.Config
            {
                formats = {
                    "png",
                    "jpg",
                    "jpeg",
                    "gif",
                    "bmp",
                    "webp",
                    "tiff",
                    "heic",
                    "avif",
                    "mp4",
                    "mov",
                    "avi",
                    "mkv",
                    "webm",
                    "pdf",
                },
                force = false, -- try displaying the image, even if the terminal does not support it
                doc = {
                    -- enable image viewer for documents
                    -- a treesitter parser must be available for the enabled languages.
                    -- supported language injections: markdown, html
                    enabled = false,
                    -- render the image inline in the buffer
                    -- if your env doesn't support unicode placeholders, this will be disabled
                    -- takes precedence over `opts.float` on supported terminals
                    inline = true,
                    -- render the image in a floating window
                    -- only used if `opts.inline` is disabled
                    float = true,
                    max_width = 80,
                    max_height = 40,
                },
                img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments" },
                -- window options applied to windows displaying image buffers
                -- an image buffer is a buffer with `filetype=image`
                wo = {
                    wrap = false,
                    number = false,
                    relativenumber = false,
                    cursorcolumn = false,
                    signcolumn = "no",
                    foldcolumn = "0",
                    list = false,
                    spell = false,
                    statuscolumn = "",
                },
                cache = vim.fn.stdpath("cache") .. "/snacks/image",
                debug = {
                    request = false,
                    convert = false,
                    placement = false,
                },
                env = {},
                ---@class snacks.image.convert.Config
                convert = {
                    notify = true, -- show a notification on error
                    ---@type snacks.image.args
                    mermaid = function()
                        local theme = vim.o.background == "light" and "neutral" or "dark"
                        return { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "{scale}" }
                    end,
                    ---@type table<string,snacks.image.args>
                    magick = {
                        default = { "{src}[0]", "-scale", "1920x1080>" },
                        math = { "-density", 600, "{src}[0]", "-trim" },
                        pdf = { "-density", 300, "{src}[0]", "-background", "white", "-alpha", "remove", "-trim" },
                    },
                },
            },
        },

    },
    {
        -- TODO: maybe someday try ollama.nvim or Ollama-Copilot
        'milanglacier/minuet-ai.nvim',
        enabled = function()
            return not at_home()
        end,
        config = function()
            require('minuet').setup {
                virtualtext = {
                    auto_trigger_ft = { 'go', 'lua', 'vim', 'python' },
                    keymap = {
                        -- accept whole completion
                        accept = '<C-]>',
                        -- accept one line
                        accept_line = '<C-y>',
                        -- accept n lines (prompts for number)
                        accept_n_lines = '<A-z>',
                        -- Cycle to prev completion item, or manually invoke completion
                        prev = '<C-;>',
                        -- Cycle to next completion item, or manually invoke completion
                        next = '<C-,>',
                        dismiss = '<C-e>',
                    },
                },
                provider = 'openai_fim_compatible',
                n_completions = 1, -- recommend for local model for resource saving
                -- I recommend beginning with a small context window size and incrementally
                -- expanding it, depending on your local computing power. A context window
                -- of 512, serves as an good starting point to estimate your computing
                -- power. Once you have a reliable estimate of your local computing power,
                -- you should adjust the context window to a larger value.
                context_window = 512,
                provider_options = {
                    openai_fim_compatible = {
                        api_key = 'TERM',
                        name = 'Ollama',
                        end_point = 'http://localhost:11434/v1/completions',
                        model = 'qwen2.5-coder:7b',
                        optional = {
                            max_tokens = 256,
                            top_p = 0.9,
                        },
                    },
                },
            }
        end,
    },
    {
        "nomnivore/ollama.nvim",
        enabled = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        -- All the user commands added by the plugin
        cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

        keys = {
            -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
            {
                "<leader>oo",
                ":<c-u>lua require('ollama').prompt()<cr>",
                desc = "ollama prompt",
                mode = { "n", "v" },
            },

            -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
            {
                "<leader>oG",
                ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
                desc = "ollama Generate Code",
                mode = { "n", "v" },
            },
        },

        ---@type Ollama.Config
        opts = {
            model = "codellama",
            url = "http://127.0.0.1:11434",
            serve = {
                on_start = false,
                command = "ollama",
                args = { "serve" },
                stop_command = "pkill",
                stop_args = { "-SIGTERM", "ollama" },
            },
            -- View the actual default prompts in ./lua/ollama/prompts.lua
            prompts = {
                Sample_Prompt = {
                    prompt = "$input $sel",
                    input_label = "> ",
                    model = "codellama",
                    action = "display",
                    system = "you are a Go expert, and gonna help me with code completion"
                },
                Generate_Code = {
                    prompt = "$buf",
                    input_label = "> ",
                    model = "codellama",
                    action = "insert",
                    system = "you are a Go expert, and gonna help me with code completion"
                }
            }
        }
    },
    {
        "norcalli/nvim-colorizer.lua",
        lazy = false,
        config = function()
            vim.o.termguicolors = true
            require 'colorizer'.setup({
                kitty = { mode = 'foreground' },
                'conf',
                'css',
            }
            )
        end
    },
    -- {
    --     "github/copilot.vim",
    --     ft = { "go" },
    -- },
    {
        'neovim/nvim-lspconfig',
        ft     = { "thrift", "html", "go", "lua", "python", "c", "cpp", "rust" },
        -- event = "VeryLazy",
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
        enabled = true,
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
            -- { 'quangnguyen30192/cmp-nvim-ultisnips' },
            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' },
        }
    },
    { 'SirVer/ultisnips',      lazy = false,   enabled = false },
    {
        "L3MON4D3/LuaSnip",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
        dependencies = { "rafamadriz/friendly-snippets" },
    },
    { 'onsails/lspkind.nvim',                    event = "VeryLazy",         lazy = true },
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
        -- keys = {
        --     { "<leader>F",  mode = { "n", "v" } },
        --     { "<leader>tf", mode = { "n" } },
        --     { "<leader>ws", mode = { "n" } },
        --     { "<leader>sf", mode = { "n" } },
        -- },
        VeryLazy = true,
        config = function()
            require("settings.telescope")
        end,
        dependencies = {
            { 'nvim-telescope/telescope-file-browser.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim',  build = 'make' },
        }
    },
    {
        "gfanto/fzf-lsp.nvim",
        lazy = true,
        enabled = false
    },
    { 'fatih/vim-go',              lazy = true,                   ft = { "go", "gomod" }, enabled = false },
    { 'tpope/vim-commentary',      event = "VeryLazy" },
    { 'ChaosNyaruko/vim-markdown', ft = "markdown",               event = "VeryLazy",     dev = false },
    { 'godlygeek/tabular',         event = "VeryLazy" },
    -- { 'christoomey/vim-tmux-navigator', enable = false,                event = "VeryLazy" },
    { 'junegunn/fzf',              build = ":call fzf#install()", event = "VeryLazy" },
    { 'junegunn/fzf.vim',          event = "VeryLazy" },
    { 'tpope/vim-fugitive',        event = "VeryLazy" },
    { 'tpope/vim-surround',        event = "VeryLazy" },
    { 'mbbill/undotree',           event = "VeryLazy" },
    -- { 'gcmt/wildfire.vim',              event = "VeryLazy" },
    {
        'NLKNguyen/papercolor-theme',
        enable = false,
        init = function()
            vim.cmd.colorscheme "PaperColor"
            vim.o.background = 'light'
        end,
    },
    {
        enabled = false,
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({
                variant = "auto",      -- auto, main, moon, or dawn
                dark_variant = "main", -- main, moon, or dawn
                dim_inactive_windows = false,
                extend_background_behind_borders = true,

                enable = {
                    terminal = true,
                    legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
                    migrations = true,        -- Handle deprecated options automatically
                },

                styles = {
                    bold = true,
                    italic = true,
                    transparency = false,
                },

                groups = {
                    border = "muted",
                    link = "iris",
                    panel = "surface",

                    error = "love",
                    hint = "iris",
                    info = "foam",
                    note = "pine",
                    todo = "rose",
                    warn = "gold",

                    git_add = "foam",
                    git_change = "rose",
                    git_delete = "love",
                    git_dirty = "rose",
                    git_ignore = "muted",
                    git_merge = "iris",
                    git_rename = "pine",
                    git_stage = "iris",
                    git_text = "rose",
                    git_untracked = "subtle",

                    h1 = "iris",
                    h2 = "foam",
                    h3 = "rose",
                    h4 = "gold",
                    h5 = "pine",
                    h6 = "foam",
                },

                palette = {
                    -- Override the builtin palette per variant
                    -- moon = {
                    --     base = '#18191a',
                    --     overlay = '#363738',
                    -- },
                },

                -- NOTE: Highlight groups are extended (merged) by default. Disable this
                -- per group via `inherit = false`
                highlight_groups = {
                    -- Comment = { fg = "foam" },
                    -- StatusLine = { fg = "love", bg = "love", blend = 15 },
                    -- VertSplit = { fg = "muted", bg = "muted" },
                    -- Visual = { fg = "base", bg = "text", inherit = false },
                },

                before_highlight = function(group, highlight, palette)
                    -- Disable all undercurls
                    -- if highlight.undercurl then
                    --     highlight.undercurl = false
                    -- end
                    --
                    -- Change palette colour
                    -- if highlight.fg == palette.pine then
                    --     highlight.fg = palette.foam
                    -- end
                end
            }
            )
        end
    },
    {
        enabled = true,
        "catppuccin/nvim",
        config = function()
            require("catppuccin").setup({
                flavour = "latte", -- latte, frappe, macchiato, mocha
                background = {     -- :h background
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = false, -- disables setting the background color.
                show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
                term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
                dim_inactive = {
                    enabled = false,            -- dims the background color of inactive window
                    shade = "dark",
                    percentage = 0.15,          -- percentage of the shade to apply to the inactive window
                },
                no_italic = false,              -- Force no italic
                no_bold = false,                -- Force no bold
                no_underline = false,           -- Force no underline
                styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
                    comments = { "italic" },    -- Change the style of comments
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
                marks = true,     -- shows a list of your marks on ' and `
                registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
                -- the presets plugin, adds help for a bunch of default keybindings in Neovim
                -- No actual key bindings are created
                spelling = {
                    enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                    suggestions = 20, -- how many suggestions should be shown in the list?
                },
                presets = {
                    operators = true,    -- adds help for operators like d, y, ...
                    motions = true,      -- adds help for motions
                    text_objects = true, -- help for text objects triggered after entering an operator
                    windows = true,      -- default bindings on <c-w>
                    nav = true,          -- misc bindings to work with windows
                    z = true,            -- bindings for folds, spelling and others prefixed with z
                    g = true,            -- bindings for prefixed with g
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
                scroll_up = "<c-u>",   -- binding to scroll up inside the popup
            },
            window = {
                border = "none",          -- none, single, double, shadow
                position = "bottom",      -- bottom, top
                margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
                padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
                winblend = 0,             -- value between 0-100 0 for fully opaque and 100 for fully transparent
                zindex = 1000,            -- positive value to position WhichKey above other floating windows.
            },
            layout = {
                height = { min = 4, max = 25 },                                               -- min and max height of the columns
                width = { min = 20, max = 50 },                                               -- min and max width of the columns
                spacing = 3,                                                                  -- spacing between columns
                align = "left",                                                               -- align columns left, center or right
            },
            ignore_missing = false,                                                           -- enable this to hide mappings for which you didn't specify a label
            hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
            show_help = true,                                                                 -- show a help message in the command line for using WhichKey
            show_keys = true,                                                                 -- show the currently pressed key and its label as a message in the command line
            triggers = "auto",                                                                -- automatically setup triggers
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
        enabled = at_home,
        event = "VeryLazy",
        init = function()
            vim.g.codeium_enabled = false
            vim.g.codeium_filetypes = { python = true, go = true, rust = false, markdown = false, c = false }
        end,
        config = function()
            -- Change '<C-g>' here to any keycode you like.
            vim.keymap.set('i', '<C-]>', function() return vim.fn['codeium#Accept']() end, { expr = true })
            vim.keymap.set('i', '<C-;>', function() return vim.fn['codeium#CycleCompletions'](1) end,
                { expr = true, desc = "codedium#CycleCompletions" })
            vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
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
        dev = false,
        config = function()
            require("ondict").setup("localhost:1345")
        end
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
        path = "~/github",
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
--
--
--
-- workaround for vim in vim's terminal
-- local exit_term_key = "<c-c>"

-- wk.register({
--   [exit_term_key] = { termcodes("<C-\\><C-N>"), "escape terminal mode" },
-- }, { mode = "t" })
-- vim.api.nvim_set_keymap("t", "<c-w>", exit_term_key .. "<c-w>", { silent = true })

-- function _G.set_terminal_keymaps()
--   local opts = { buffer = 0 }
--   vim.keymap.set("n", exit_term_key, "i" .. exit_term_key, opts)
-- end

-- vim.api.nvim_create_autocmd({ "TermOpen" }, {
--   pattern = "term://*",
--   callback = function()
--     set_terminal_keymaps()
--   end,
-- })
--
local on_attach = function(client, bufnr)
    vim.notify(string.format("bufnr: %d", bufnr))
    local bufopts = { noremap = true, silent = true, buffer = bufnr, desc = "buffer mappings in markdown" }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    -- if client.name ~= 'gopls' then
    vim.keymap.set('n', 'goc', vim.lsp.buf.incoming_calls, bufopts)
    -- end
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '\\f', vim.lsp.buf.format, bufopts)
end

local mdlsp = os.getenv("HOME") .. "/go/bin/educationalsp"

local client, err = nil, nil
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function(ev)
        if not client then
            client, err = vim.lsp.start_client {
                name = "markdownlint",
                cmd = { mdlsp },
                on_attach = on_attach,
            }
            vim.notify(string.format("client id: %d", client))
        end
        if not client == nil then
            vim.notify(string.format("hey, you didn't do the client thing good, %s", err))
            return
        end
        vim.lsp.buf_attach_client(0, client)
    end
}
)
