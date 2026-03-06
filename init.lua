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
--      Maybe emmet-vim?
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
Plug("sindrets/diffview.nvim")
Plug("nomnivore/ollama.nvim")
Plug("p00f/clangd_extensions.nvim")

-- For avante
Plug('echasnovski/mini.icons')
Plug('HakonHarnes/img-clip.nvim')
Plug('stevearc/dressing.nvim') -- for enhanced input UI
Plug('folke/snacks.nvim') -- for modern input UI
Plug('MeanderingProgrammer/render-markdown.nvim')
Plug('MunifTanjim/nui.nvim')
Plug('yetone/avante.nvim', { ['branch'] = 'main', ['do'] = 'make'})


-- Conditionally install this plugin if hostname is "vivint-laptop"
local hostname = vim.fn.hostname()
if hostname == "vivint-laptop" then
    -- Plug("github/copilot.vim")
    Plug('zbirenbaum/copilot.lua')
    Plug("copilotlsp-nvim/copilot-lsp")
end

-- Leaving this in here for a bit until I'm sure I don't want it in.
--local should_use_gitlab_plugin = os.getenv("GITLAB_TOKEN")
--if should_use_gitlab_plugin then
--    Plug("MunifTanjim/nui.nvim")
--    -- Plug("nvim-lua/plenary.nvim")
--    Plug("stevearc/dressing.nvim") -- Recommended but not required. Better UI for pickers.
--    Plug("nvim-tree/nvim-web-devicons") -- Recommended but not required. Icons in discussion tree.
--    -- The actual plugin:
--    Plug("harrisoncramer/gitlab.nvim", { -- For gitlab MRs
--        ['do'] = function()
--            require('diffview')
--            print("Building GO Gitlab API server...")
--            require('gitlab.server').build()
--        end
--    })
--end -- use gitlab.nvim plugin

vim.call('plug#end')

require('codeanalysis')
require('appearance')
require('customkeybindings')
require('cheatsheet')
require('llm')
-- if should_use_gitlab_plugin then
--     require('gitlab_config')
-- end

----vim.opt.termguicolors = true
--vim.cmd [[
--    colorscheme koehler
--    ]]
