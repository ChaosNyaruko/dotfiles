-- print("loading nvim-cmp")
-- Set up nvim-cmp.
local status, cmp = pcall(require, 'cmp')
if not status then return end

local preset_insert_mapping = cmp.mapping.preset.insert({
    -- ['<C-n>'] = cmp.config.disable, -- C-n/C-p is used in my Emacs like keymapping in insert mode
    -- ['<C-p>'] = cmp.config.disable,
    ['<C-b>'] = cmp.mapping.scroll_docs( -4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-s>'] = cmp.mapping.complete(),
    ['<C-y>'] = cmp.mapping.confirm(),
    ['<C-e>'] = cmp.mapping.abort(),
})

-- print(vim.inspect(cmp.mapping.preset.insert()))
-- print(vim.inspect(cmp.mapping.preset.cmdline()))
preset_insert_mapping["<CR>"] = cmp.mapping({
    i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false })
        else
            fallback()
        end
    end,
    -- s = cmp.mapping.confirm({ select = true }),
    -- c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
})

preset_insert_mapping['<C-n>'] = cmp.mapping({
    i = function(fallback)
        if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        else
            fallback()
        end
    end
})

preset_insert_mapping['<C-p>'] = cmp.mapping({
    i = function(fallback)
        if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        else
            fallback()
        end
    end
})

-- print(vim.inspect(preset_insert_mapping['<C-n>']))

cmp.setup({
    preselect = cmp.PreselectMode.None,
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = preset_insert_mapping,
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- Set up lspconfig.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['rust-analyzer'].setup {
--     capabilities = capabilities
-- }

local kind_icons = {}
cmp.setup {
    formatting = {
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
                    buffer = "[Buffer]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    nvim_lua = "[Lua]",
                    latex_symbols = "[LaTeX]",
                })[entry.source.name]
            return vim_item
        end
    },
}

vim.opt.completeopt = 'menu,menuone,noselect'
-- local cmp = require('cmp')
-- local lspkind = require('lspkind')
-- cmp.setup {
--   formatting = {
--     format = lspkind.cmp_format(),
--   },
-- }
