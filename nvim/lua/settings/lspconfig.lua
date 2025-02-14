-- print("load lspconfig")
local status, nvim_lsp = pcall(require, 'lspconfig')

if (not status) then return end

local M = {}

vim.diagnostic.config({ virtual_text = true })

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { buffer = false, noremap = true, silent = true, desc = "mappings in lspconfig global" }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
-- vim.opt.completeopt = 'menuone,noinsert'

local function document_highlight()
    vim.lsp.buf.clear_references()
    vim.lsp.buf.document_highlight()
end

local function on_list(options)
    vim.fn.setqflist({}, ' ', options)
    vim.api.nvim_command('cfirst')
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    print("lsp attached: ", client.name)
    -- if client.server_capabilities.documentSymbolProvider then
    --     require("breadcrumb").attach(client, bufnr)
    -- end
    -- print(vim.inspect(client.server_capabilities))
    local format_group = vim.api.nvim_create_augroup("LspFormatGroup", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        group = format_group,
        -- buffer = bufnr,
        pattern = { "*.rs", "*.go", "go.mod" },
        desc = "LspFormatGroup",
        callback = function()
            vim.notify(string.format("format by lsp: %s", client.name), vim.log.levels.WARN)
            vim.lsp.buf.format()
        end,
    })
    vim.keymap.set('n', '<leader>R', function()
        vim.cmd [[LspRestart]]
    end)
    if client.name == 'gopls' then
        if vim.fn.expand("%:t") == "go.mod" then
            -- print(string.format('gopls attached, set noautoread for my automatic LspRestart'))
            -- vim.bo.autoread = false
        end
        vim.api.nvim_create_augroup('my_go_lsp', {
            clear = true
        })
        -- print("gopls is used")
        -- vim.api.nvim_create_autocmd({"FileType"}, {
        --     group = 'my_go_lsp',
        --     pattern = {"gomod"},
        --     callback = function(ev)
        --         print(string.format('gomod noautoread'))
        --         vim.bo.autoread = false
        --     end
        -- })
        -- TODO:
        -- if "FileChangedShell" is used, this can only work when autoread is not set.
        -- FileChangedShellPost works fine.
        -- not really figure it out yet.
        -- maybe go#lsp#DidChange is what I need?
        vim.api.nvim_create_autocmd({ "FileChangedShellPost", "BufWritePost" }, {
            group = 'my_go_lsp',
            pattern = { "go.mod" },
            callback = function(ev)
                -- print(string.format('%s event fired: %s', os.time(), vim.inspect(ev)))
                print(string.format('[%s] go.mod update detected, restart lsp', os.date('%Y-%m-%d %H:%M:%S')))
                vim.api.nvim_command("LspRestart")
            end
        })
        -- https://www.reddit.com/r/neovim/comments/f0qx2y/automatically_reload_file_if_contents_changed/
        -- it's not useful for this problem, but just remind me of sth.
        -- vim.cmd [[
        -- autocmd FocusGained *.go checktime
        -- autocmd FocusGained go.mod checktime
        -- ]]
    end
    local cap = client.server_capabilities
    if cap.documentHighlightProvider then
        vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
        -- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" },
        --     { buffer = bufnr, callback = vim.lsp.buf.clear_references })
        -- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" },
        --     { buffer = bufnr, callback = vim.lsp.buf.document_highlight })
        vim.keymap.set('n', '<space>8', document_highlight, opts)
    end
    -- autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
    -- autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.document_highlight()
    -- formatting, refer to github.com/craftzdog/dotfiles
    -- if client.server_capabilities.documentFormattingProvider --[[and client.name ~= 'gopls'--]] then
    if client.server_capabilities.documentFormattingProvider then
        -- vim.api.nvim_command [[augroup Format]]
        -- vim.api.nvim_command [[autocmd! * <buffer>]]
        -- vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format() ]]
        -- vim.api.nvim_command [[augroup END]]
        vim.cmd [[
            command! -nargs=0 -bang -buffer LspFormat lua vim.lsp.buf.format()
        ]]
    end
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr, desc = "buffer mappings in lspconfig on attach" }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation { on_list = on_list } end, bufopts)
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
-- capabilities["textDocument"] = {
--     semanticHighlightingCapabilities = {
--         semanticHighlighting = true
--     }
-- }

-- print(vim.inspect(capabilities))
vim.lsp.set_log_level("INFO")
-- for Go, use vim-go Plugin instead
nvim_lsp.gopls.setup {
    cmd = { "gopls", "-remote=auto" },
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
}

-- for Python
nvim_lsp.pyright.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    -- cmd = {"/Users/bill/miniconda3/envs/langchain/bin/pyright-langserver", "--stdio"},
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
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
                -- target = "thumbv7em-none-eabihf"
            },
            completion = {
                postfix = {
                    enable = false,
                },
            },
        },
    },
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        signs = true,
        update_in_insert = true,
    }
)

-- for HTML
nvim_lsp.html.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
}

M.on_attach = on_attach

return M
