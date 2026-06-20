-- ── Parser installation ──────────────────────────────────────────────
-- nvim-treesitter (main branch) only manages parsers and queries now.
-- Highlighting / folding / indentation are Neovim built-ins.
require('nvim-treesitter').install({
    'lua', 'json', 'vim', 'query', 'go', 'python', 'java',
}):wait(300000)

-- ── Highlighting (built-in vim.treesitter) ────────────────────────────
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'go', 'rust', 'c', 'cpp', 'java', 'lua', 'json', 'python', 'query' },
    callback = function(ev)
        -- vimdoc has a strange error, skip it
        if vim.bo[ev.buf].filetype == 'vimdoc' then return end
        local ok = pcall(vim.treesitter.start)
        if not ok then return end
    end,
})

-- ── Indentation (nvim-treesitter experimental) ────────────────────────
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'go', 'rust', 'c', 'cpp', 'java', 'lua', 'python' },
    callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

-- ── nvim-treesitter-context ───────────────────────────────────────────
local ctx_ok, ctx = pcall(require, 'treesitter-context')
if ctx_ok then
    ctx.setup {
        enable            = true,
        multiwindow       = false,
        max_lines         = 0,
        min_window_height = 0,
        line_numbers      = true,
        multiline_threshold = 20,
        trim_scope        = 'outer',
        mode              = 'cursor',
        separator         = nil,
        zindex            = 20,
        on_attach         = nil,
    }

    vim.cmd [[hi TreesitterContextBottom gui=underline guisp=Grey]]

    vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context(vim.v.count1)
    end, { silent = true, desc = "Jump to treesitter context" })
end

-- ── nvim-treesitter-textobjects ───────────────────────────────────────
local to_ok, _ = pcall(require, 'nvim-treesitter-textobjects')
if not to_ok then return end

local select = require('nvim-treesitter-textobjects.select')
local move   = require('nvim-treesitter-textobjects.move')

-- select
require('nvim-treesitter-textobjects').setup {
    select = {
        lookahead = true,
        selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer']  = 'V',
            ['@class.outer']     = '<c-v>',
        },
        include_surrounding_whitespace = true,
    },
    move = {
        set_jumps = true,
    },
}

-- text-object selection keymaps
for _, mode in ipairs({ 'x', 'o' }) do
    vim.keymap.set(mode, 'af', function()
        select.select_textobject('@function.outer', 'textobjects')
    end, { desc = 'Select outer function' })
    vim.keymap.set(mode, 'if', function()
        select.select_textobject('@function.inner', 'textobjects')
    end, { desc = 'Select inner function' })
    vim.keymap.set(mode, 'ac', function()
        select.select_textobject('@class.outer', 'textobjects')
    end, { desc = 'Select outer class' })
    vim.keymap.set(mode, 'ic', function()
        select.select_textobject('@class.inner', 'textobjects')
    end, { desc = 'Select inner class' })
    vim.keymap.set(mode, 'as', function()
        select.select_textobject('@local.scope', 'locals')
    end, { desc = 'Select scope' })
end

-- move keymaps
vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
    move.goto_next_start('@function.outer', 'textobjects')
end, { desc = 'Next function start' })

vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
    move.goto_next_end('@function.outer', 'textobjects')
end, { desc = 'Next function end' })

vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
    move.goto_previous_start('@function.outer', 'textobjects')
end, { desc = 'Previous function start' })

vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
    move.goto_previous_end('@function.outer', 'textobjects')
end, { desc = 'Previous function end' })

vim.keymap.set({ 'n', 'x', 'o' }, ']o', function()
    move.goto_next_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
end, { desc = 'Next loop start' })

vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
    move.goto_next_start('@local.scope', 'locals')
end, { desc = 'Next scope' })

vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
    move.goto_next_start('@fold', 'folds')
end, { desc = 'Next fold' })
