-- print("lua/plugins.lua is loading")
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[ packadd packer.nvim ]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

local status, packer = pcall(require, 'packer')
if (not status) then
    print("Packer is not installed")
    return
end

packer.startup(function(use)
    use 'wbthomason/packer.nvim'
    -- use 'tpope/vim-fugitive'
    -- use 'tpope/vim-commentary'

    use 'neovim/nvim-lspconfig' -- LSP
    use 'williamboman/mason.nvim'
    -- use 'onsails/lspkind-nvim' -- vscode-like pictograms
    -- use 'L3MON4D3/LuaSnip'
    -- use 'jose-elias-alvarez/null-ls.nvim'
    --
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'hrsh7th/nvim-cmp' -- complete engine
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'quangnguyen30192/cmp-nvim-ultisnips'
    -- use { 'fatih/vim-go', tag = '*' }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use {
        'nvim-treesitter/playground'
    }

    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-file-browser.nvim'
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    -- use 'kyazdani42/nvim-web-devicons' -- for telescope file icons

    -- use 'akinsho/nvim-bufferline.lua'
    -- use 'norcalli/nvim-colorizer.lua'
    -- use({
    --     "iamcco/markdown-preview.nvim",
    --     run = function() vim.fn["mkdp#util#install"]() end,
    -- })

    -- use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install",
    --     setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

    use "gfanto/fzf-lsp.nvim"
    -- use { 'junegunn/fzf', run = ":call fzf#install()" }
    -- use { 'junegunn/fzf.vim' }
    if packer_bootstrap then
        require('packer').sync()
    end
end)

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

require("settings.mason")
require("settings.fzf")
require("settings.lspconfig")
require("settings.nvim-cmp")
require("settings.lualine")
require("settings.treesitter")
require("settings.telescope")
