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

require("lazy").setup({
    'neovim/nvim-lspconfig', -- LSP
    'williamboman/mason.nvim',
    { 'nvim-lualine/lualine.nvim',       dependencies = { 'kyazdani42/nvim-web-devicons' } },
    'hrsh7th/nvim-cmp',
    'onsails/lspkind.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'quangnguyen30192/cmp-nvim-ultisnips',
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { 'nvim-treesitter/playground',      enabled = false },
    'nvim-treesitter/nvim-treesitter-context',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
    "gfanto/fzf-lsp.nvim",
})

require("settings.mason")
require("settings.fzf")
require("settings.lspconfig")
require("settings.nvim-cmp")
require("settings.lualine")
require("settings.treesitter")
require("settings.telescope")
