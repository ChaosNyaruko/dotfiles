local status, telescope = pcall(require, 'telescope')
if (not status) then return end

if (vim.g.fzf_loaded) then return end
local actions = require('telescope.actions')

function telescope_buffer_dir()
    return vim.fn.expand('%:p:h')
end

local fb_actions = require 'telescope'.extensions.file_browser.actions

local add_selected_to_qflist = function (prompt_bufnr)
    -- print("add selected to qflist, use `copen` to open quickfix window")
    actions.add_selected_to_qflist(prompt_bufnr)
    vim.cmd [[copen]]
end

telescope.setup {
    defaults = {
        mappings = {
            n = {
                ['q'] = actions.close,
                ['<leader>A'] = add_selected_to_qflist
            },
            -- i = {
            --     ['A'] = add_selected_to_qflist
            -- }
        }
    },
    extensions = {
        file_browser = {
            theme = 'dropdown',
            hijack_netrw = false,
            mappings = {
                ['i'] = {
                    ['<C-w>'] = function() vim.cmd('normal vbd') end,
                },
                ['n'] = {
                    ['c'] = fb_actions.create,
                    ['H'] = fb_actions.goto_parent_dir,
                    ['/'] = function()
                        vim.cmd('startinsert')
                    end
                }
            },
            fzf = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            }
        }
    }
}

telescope.load_extension('file_browser')
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension('fzf')

local opts = { noremap = true, silent = true }
-- vim.keymap.set('n', '<c-p>',
--     '<cmd>lua require("telescope.builtin").find_files({ no_ignore = false, hidden = true})<cr>'
--     , opts)
vim.keymap.set('n', '<leader>tf', '<cmd>lua require("telescope.builtin").live_grep()<cr>', opts)
vim.keymap.set('n', '<leader>F', '<cmd>lua require("telescope.builtin").grep_string()<cr>', opts)
vim.keymap.set('v', '<leader>F', '<cmd>lua require("telescope.builtin").grep_string()<cr>', opts)
-- vim.keymap.set('n', '<leader>b', '<cmd>lua require("telescope.builtin").buffers()<cr>', opts)
vim.keymap.set('n', '<leader>h', '<cmd>lua require("telescope.builtin").help_tags()<cr>', opts)
vim.keymap.set('n', '<leader>td', '<cmd>lua require("telescope.builtin").diagnostics()<cr>', opts)
vim.keymap.set('n', '<leader>c', '<cmd>lua require("telescope.builtin").lsp_incoming_calls()<cr>', opts)
vim.keymap.set('n', '<leader>r', '<cmd>lua require("telescope.builtin").lsp_references()<cr>', opts)
vim.keymap.set('n', '<leader>ws', '<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<cr>', opts)
vim.keymap.set('n', '<leader>sf',
    '<cmd>lua require("telescope").extensions.file_browser.file_browser({ path = "%:p:h", cwd = telescope_buffer_dir(), respect_git_ignore = false, hidden =true, grouped = true, previewer = false, initial_mode = "normal", layout_config = { height = 40}})<cr>'
    , opts)
