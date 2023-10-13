local status, fzf_lsp = pcall(require, 'fzf_lsp')
if not status then return end

-- vim.api.nvim_set_keymap('n', '<leader>ws', ":WorkspaceSymbols ", {
--     noremap = true,
--     desc = "a shortcut for WorkspaceSymbols in fzf_lsp"
-- })

-- require 'fzf_lsp'.setup()
-- only use fzf_lsp handlers in some cases, sometimes the original quickfix windows is better.
vim.lsp.handlers["callHierarchy/incomingCalls"] = require 'fzf_lsp'.incoming_calls_handler
