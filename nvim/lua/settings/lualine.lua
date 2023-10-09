local status, line = pcall(require, 'lualine')
if not status then
    return
end

local function codium_status()
    return "{...}" .. vim.fn['codeium#GetStatusString']()
end

line.setup {
    options = {
        icons_enabled = true,
        theme = 'onelight',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = {
            'mode',
        },

        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        -- lualine_z = { 'location', [[%3{codeium#GetStatusString()}]] }
        lualine_z = { 'location'}, --codium_status }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

vim.o.showmode = false
vim.o.laststatus = 3
