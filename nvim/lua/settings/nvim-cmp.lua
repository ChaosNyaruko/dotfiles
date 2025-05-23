-- print("loading nvim-cmp")
-- Set up nvim-cmp.
local status, cmp = pcall(require, 'cmp')
if not status then return end

local cn = function(fallback)
    -- print(vim.inspect(vim.api.nvim_get_keymap('i')))
    if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
    else
        fallback()
    end
end

local cp = function(fallback)
    if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
    else
        fallback()
    end
end

local preset_insert_mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.config.disable, -- C-n/C-p is used in my Emacs like keymapping in insert mode
    ['<C-p>'] = cmp.config.disable,
    -- ['<C-n>'] = cn, -- C-n/C-p is used in my Emacs like keymapping in insert mode
    -- ['<C-p>'] = cp,
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-s>'] = cmp.mapping.complete(),
    ['<C-y>'] = cmp.mapping.confirm(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- ["<A-y>"] = require('minuet').make_cmp_map()
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
    i = cn,
})

preset_insert_mapping['<C-p>'] = cmp.mapping({
    i = cp,
})

local luasnip = require("luasnip")
-- print(vim.inspect(preset_insert_mapping['<C-n>']))
preset_insert_mapping['<C-l>'] = cmp.mapping(
    function(fallback)
        if cmp.visible() then
            if luasnip.expandable() then
                luasnip.expand()
            end
        else
            if luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end
    end,
    { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
)

preset_insert_mapping['<C-h>'] = cmp.mapping(
    function(fallback)
        fallback()
    end,
    { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
)

require('my_snippets').register_cmp_source()
cmp.setup({
    preselect = cmp.PreselectMode.None,
    confirmation = {
        get_commit_characters = function(commit_characters)
            return {}
        end
    },
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = preset_insert_mapping,
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'snp' },
        { name = 'nvim_lsp_signature_help' }, -- lsp_signature.nvim maybe better?
        -- { name = 'vsnip' }, -- For vsnip users.
        { name = 'luasnip' },                 -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
        -- { name = 'minuet' },
    }),
    experimental = {
        ghost_text = false
    },
    performance = {
        fetching_timeout = 5000,
    }
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

local preset_cmdline = cmp.mapping.preset.cmdline()
preset_cmdline['<C-n>'] = cmp.mapping({
    c = cn
})
preset_cmdline['<C-p>'] = cmp.mapping({
    c = cp
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--     mapping = preset_cmdline,
--     sources = {
--         { name = 'buffer' }
--     }
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = preset_cmdline,
    sources = cmp.config.sources({
        { name = 'path', keyword_length = 8 }
    }, {
        { name = 'cmdline', keyword_length = 8 }
    })
})

-- Set up lspconfig.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['rust-analyzer'].setup {
--     capabilities = capabilities
-- }

local kind_icons = {}
local lspkind = require('lspkind')
cmp.setup {
    formatting = {
        format = lspkind.cmp_format({
            -- mode = "symbol_text",
            mode = "text",
            menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                latex_symbols = "[Latex]",
            })
        }),
        -- format = function(entry, vim_item)
        --     -- Kind icons
        --     vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
        --     -- Source
        --     vim_item.menu = ({
        --             buffer = "[Buffer]",
        --             nvim_lsp = "[LSP]",
        --             luasnip = "[LuaSnip]",
        --             nvim_lua = "[Lua]",
        --             latex_symbols = "[LaTeX]",
        --         })[entry.source.name]
        --     return vim_item
        -- end
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
