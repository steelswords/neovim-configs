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
--==================================================
-- QUICK KEYBINDING REFERENCE
--==================================================
-- \ff   Telescope find find_files
-- \fg   Telescope live grep through CWD and children
-- \fc   Telescope live grep through CWD and children for word under cursor
-- \gl   Telescope show git commits
-- \gd   Show buffer's git history in git commits 
-- C-j   Expand Ultisnips snippet
--
--            LSP stuff:
-- <space>e Open float of diagnostics
-- [d       goto previous diagnostic
-- ]d       goto next diagnostic
-- <space>q  vim.diagnostic.setloclist
-- gD       goto declaration
-- gd       goto definition
--
-- K        show documentation
-- gi       goto implementation
-- C-k      signature help
-- <space>D  workspace definition 
-- <space>rn  buffer rename 
-- <space>ca  do code action
-- gr         show references to buffer
-- C-h        switch between header and source in cpp
-- C-e        abort autocomplete
-- C-b        scroll autocomplete docs
-- C-f        scroll autocomplete docs
-- C-<space>  autocomplete complete
-- <CR>       autocomplete confirm
--
-- gn Show incoming calls in telescope
-- gu Show outgoing calls in telescope
--
-- Other things that could be configured easily if we want:
-- - showing definitions, incoming calls, outgoing calls, and other LSP goodness through Telescope

----------------------------------------------------
-- Plugins
----------------------------------------------------
local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug("tomasiser/vim-code-dark")
Plug("nvim-lua/plenary.nvim") -- Required for telescope
Plug("nvim-telescope/telescope.nvim")
Plug("neovim/nvim-lspconfig")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-cmdline")
Plug("hrsh7th/nvim-cmp")
Plug("SirVer/ultisnips")
Plug("quangnguyen30192/cmp-nvim-ultisnips")
Plug("lewis6991/gitsigns.nvim") -- For git decorations
Plug("tpope/vim-fugitive")
Plug("williamboman/mason.nvim") -- For automatic LSP installation
Plug("williamboman/mason-lspconfig.nvim")
Plug("windwp/nvim-projectconfig")
Plug("git@github.com:mrcjkb/rustaceanvim")

vim.call('plug#end')

require('codeanalysis')
require('appearance')
require('customkeybindings')
