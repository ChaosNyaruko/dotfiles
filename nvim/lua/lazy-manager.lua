vim.opt.completeopt = 'menu,menuone,noselect'

vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('thriftls')
local function document_highlight()
    vim.lsp.buf.clear_references()
    vim.lsp.buf.document_highlight()
end
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        -- local opts = { buffer = true, noremap = true, silent = true, desc = "mapping for vim.lsp" }
        local bufopts = {
            noremap = true,
            silent = true,
            buffer = args.buf,
            desc =
            "buffer mappings in lspconfig on attach"
        }
        vim.diagnostic.config({ virtual_text = true })
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, bufopts)
        vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, bufopts)
        vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, bufopts)
        vim.keymap.set('n', '<space>q',
            function() vim.diagnostic.setloclist({ severity = vim.diagnostic.severity.ERROR }) end, bufopts)

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'goc', vim.lsp.buf.incoming_calls, bufopts)
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

        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        print("attached: ", client.name)
        if client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
            vim.keymap.set('n', '<space>8', document_highlight, bufopts)
        end


        if client:supports_method('textDocument/implementation') then
            -- Create a keymap for vim.lsp.buf.implementation ...
            vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, bufopts)
        end
        -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
        if client:supports_method('textDocument/completion') then
            -- Optional: trigger autocompletion on EVERY keypress. May be slow!
            -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
            -- client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end

        -- autoformat for go and rust
        local format_group = vim.api.nvim_create_augroup("LspFormatGroup", { clear = true })
        vim.api.nvim_create_autocmd({ "BufWritePre" }, {
            group = format_group,
            buffer = args.buf,
            desc = "LspFormatGroup",
            callback = function()
                vim.notify(string.format("format by lsp: %s", client.name), vim.log.levels.WARN)
                vim.lsp.buf.format()
            end,
        })
    end,
})

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
if not vim.uv.fs_stat(lazypath, nil) then
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
    local user = os.getenv("HOME")
    if not user then
        return false
    end
    if user:find("bill") or user:find("bat") or user:find("ark") then
        return true
    else
        return false
    end
end


local function toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == 'nil' then
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
                input_word_completion = true,
                hidden_buffer = false,
            }
            vim.keymap.set("n", '<leader>cc', "<cmd>buffer! *compilation*<cr>",
                { buffer = false, desc = "quickly open compilation buffer" })
            vim.keymap.set("n", '<F5>', "<cmd>Compile<cr>",
                { buffer = false, desc = "quickly launch Compile" })
            vim.keymap.set("n", '<leader>cn', "<cmd>NextError<cr>",
                { buffer = false, desc = "quickly jump to next error" })
            vim.keymap.set("n", '<leader>cp', "<cmd>PrevError<cr>",
                { buffer = false, desc = "quickly jump to previous error" })
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
        'milanglacier/minuet-ai.nvim',
        enabled = function()
            return not at_home()
        end,
        ft = { "go" },
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
    {
        enabled = false,
        'neovim/nvim-lspconfig',
        ft     = { "thrift", "html", "go", "lua", "python", "c", "cpp", "rust" },
        -- event = "VeryLazy",
        config = function()
            require("settings.lspconfig")
            require("settings.fzf")
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
        event = "UIEnter",
        enabled = true,
        config = function()
            require("settings.lualine")
        end
    },
    {
        enabled = false,
        'hrsh7th/nvim-cmp',
        event = { "InsertEnter" },
        ft = { "go", "rust", "python" },
        config = function()
            require("settings.nvim-cmp")
        end,
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            -- { 'L3MON4D3/LuaSnip' },
            -- { 'saadparwaiz1/cmp_luasnip' },
        }
    },
    {
        "L3MON4D3/LuaSnip",
        enabled = false,
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
        ft = { "go", "sh", "rust" },
        dependencies = { "rafamadriz/friendly-snippets" },
    },
    { 'onsails/lspkind.nvim',                    event = "VeryLazy",         lazy = true },
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = true,
        ft = { "go", "rust", "c", "cpp" },
        cmd = { "TSInstallInfo", "TSUpdate" },
        build = ':TSUpdate',
        config = function()
            require("settings.treesitter")
        end
    },
    { 'nvim-treesitter/playground',              cmd = "TSPlaygroundToggle", enabled = true,       event = "VeryLazy" },
    { 'nvim-treesitter/nvim-treesitter-context', event = "VeryLazy",         ft = { "go", "rust" } },
    { 'nvim-lua/plenary.nvim',                   event = "VeryLazy" },
    {
        'nvim-telescope/telescope.nvim',
        VeryLazy = true,
        config = function()
            require("settings.telescope")
        end,
        keys = {
            {
                '<leader>F',
                '<cmd>lua require("telescope.builtin").grep_string()<cr>',
                mode = { "n", "v" },
                { noremap = true, silent = true },
            },
        },
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
    { 'tpope/vim-commentary', event = "VeryLazy" },
    {
        'ChaosNyaruko/vim-markdown',
        branch = "353",
        ft = "markdown",
        event = "VeryLazy",
        dev = false
    },
    { 'godlygeek/tabular',    event = "VeryLazy" },
    { 'junegunn/fzf',         build = ":call fzf#install()", event = "VeryLazy" },
    { 'junegunn/fzf.vim',     event = "VeryLazy" },
    { 'tpope/vim-fugitive',   event = "VeryLazy" },
    { 'tpope/vim-surround',   event = "VeryLazy" },
    { 'mbbill/undotree',      event = "VeryLazy" },
    {
        enabled = true,
        "catppuccin/nvim",
        config = function()
            require("catppuccin").setup({
                -- flavour = "latte", -- latte, frappe, macchiato, mocha
                background = { -- :h background
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
    {
        'iamcco/markdown-preview.nvim',
        ft = "markdown",
        build = function() vim.fn["mkdp#util#install"]() end,
        event = "VeryLazy"
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
        "ChaosNyaruko/ondict",
        event = "VeryLazy",
        build = function(plugin)
            require("ondict").install(plugin.dir)
        end,
        dev = true,
        config = function()
            require("ondict").setup("auto")
        end
    },
    {
        "tpope/vim-rsi",
        enabled = false,
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


--------
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
if true then
    return
end

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
            client, err = vim.lsp.start {
                name = "markdownlint",
                cmd = { mdlsp },
                on_attach = on_attach,
            }
            vim.notify(string.format("client id: %d", client))
        end
        if not client then
            vim.notify(string.format("hey, you didn't do the client thing good, %s", err))
            return
        end
        vim.lsp.buf_attach_client(0, client)
    end
}
)
