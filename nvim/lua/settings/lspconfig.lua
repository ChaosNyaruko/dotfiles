-- print("load lspconfig")
local status, nvim_lsp = pcall(require, 'lspconfig')

if (not status) then return end

vim.diagnostic.config({ virtual_text = true })

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true, desc = "mappings in lspconfig global" }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
-- vim.opt.completeopt = 'menuone,noinsert'

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local cap = client.server_capabilities
    if cap.document_highlight then
        vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" },
            { buffer = bufnr, callback = vim.lsp.buf.clear_references })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" },
            { buffer = bufnr, callback = vim.lsp.buf.document_highlight })
    end
    -- autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
    -- autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.document_highlight()
    -- formatting, refer to github.com/craftzdog/dotfiles
    if client.server_capabilities.documentFormattingProvider and client.name ~= 'gopls' then
        vim.api.nvim_command [[augroup Format]]
        vim.api.nvim_command [[autocmd! * <buffer>]]
        vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format() ]]
        vim.api.nvim_command [[augroup END]]
    end
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr, desc = "buffer mappings in lspconfig on attach" }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    -- if client.name ~= 'gopls' then
    vim.keymap.set('n', 'goc', vim.lsp.buf.incoming_calls, bufopts)
    -- end
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
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

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}
-- for Lua, especially neovim lua configurations
-- nvim_lsp.sumneko_lua.setup {
--     on_attach = on_attach,
--     settings = {
--         Lua = {
--             diagnostics = {
--                 globals = { 'vim', 'hs', 'spoon' }
--             },

--             workspace = {
--                 library = vim.api.nvim_get_runtime_file("", true),
--                 checkThirdParty = false
--             }
--         }
--     }
-- }

nvim_lsp.lua_ls.setup {
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- for Go, use vim-go Plugin instead
nvim_lsp.gopls.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
}

-- for Python
nvim_lsp.pyright.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
}

-- for C++
nvim_lsp.clangd.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
}

-- for Rust
nvim_lsp.rust_analyzer.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
}
