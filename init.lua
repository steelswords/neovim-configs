--------------------------------------------------------------------------------
-- Name:           init.lua
-- Author:         Tristan Andrus
-- Date of Origin: 21 April 2024
-- Description:    Neovim configs, v 2.0
--                 I took a weekend and completely rewrote my aging vim configs.
--                 I had been evolving the same file since I started my vim journey
--                 around 2018, and it had accumulated a lot of cruft. So now the
--                 configs are sleek, modern, written in Lua, and specifically targeting
--                 Neovim.
--                 The goals of this rewrite are to simplify to the point where I
--                 understand every line that goes into my configs, rather than a
--                 bunch of copy-pasted nonsense from the web.
--------------------------------------------------------------------------------

----------------------------------------------------
-- Setup
----------------------------------------------------
-- Packages to install:
--     silversearcher-ag
--     https://github.com/BurntSushi/ripgrep
--     clangd
--     npm i -g pyright
--     rustup component add rust-analyzer....

-- TODO when I've gotten more used to this setup, and ironed out the kinks:
--      tpope/vim-surround
--      automatically installing LSPs with mason.nvim
--          QML support
--      Mabye emmet-vim?
--      Maybe leap.nvim?
--
-- Other things that could be configured easily if we want:
--   - showing definitions, incoming calls, outgoing calls, and other LSP goodness through Telescope"
--   - showing definitions, incoming calls------------------------------------------------
-- Plugins
----------------------------------------------------
local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug("tomasiser/vim-code-dark")
Plug("nvim-lua/plenary.nvim") -- Required for telescope
Plug("nvim-telescope/telescope.nvim")
Plug("neovim/nvim-lspconfig")
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-cmdline")
Plug("SirVer/ultisnips")
Plug("quangnguyen30192/cmp-nvim-ultisnips")
Plug("lewis6991/gitsigns.nvim") -- For git decorations
Plug("tpope/vim-fugitive")
Plug("williamboman/mason.nvim") -- For automatic LSP installation
Plug("williamboman/mason-lspconfig.nvim")
Plug("windwp/nvim-projectconfig")
Plug("git@github.com:mrcjkb/rustaceanvim")
Plug("isobit/vim-caddyfile")

-- For flutter
Plug('stevearc/dressing.nvim') -- optional for vim.ui.select
Plug('nvim-flutter/flutter-tools.nvim')


vim.call('plug#end')

require('codeanalysis')
require('appearance')
require('customkeybindings')
require('cheatsheet')

----vim.opt.termguicolors = true
--vim.cmd [[
--    colorscheme koehler
--    ]]
