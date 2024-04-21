----------------------------------------------------
-- Setup
----------------------------------------------------
-- Packages to install:
--     silversearcher-ag
--     https://github.com/BurntSushi/ripgrep
--     clangd
--     npm i -g pyright


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

vim.call('plug#end')

----------------------------------------------------
-- LSP
----------------------------------------------------
-- My goal here is simple: I want the best features I can get, while minimizing
-- the complexity and number of modules, and while maximizing my understanding of
-- how it works so I can fix it when it breaks. To this end, I use the built-in
-- Neovim LSP with the neovim/nvim-lspconfig as a plugin.

-- TODO: These only work if I source this file, i.e. run this code twice.
--require('vim.lsp')


-- Start LSPs
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.clangd.setup {}
lspconfig.rust_analyzer.setup{
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false;
      }
    }
  }
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
    vim.api.nvim_set_keymap('n', '<C-h>', ':ClangdSwitchSourceHeader<CR>', { noremap = true, silent = true })

  end,
})

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'ultisnips' }, -- For ultisnips users.
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- TODO: Make list of lsp servers, or set this up individual files.
require('lspconfig')['clangd'].setup { capabilities = capabilities }
require('lspconfig')['rust_analyzer'].setup { capabilities = capabilities }
require('lspconfig')['pyright'].setup { capabilities = capabilities }

----------------------------------------------------
-- Text appearence configuration
----------------------------------------------------
-- Enable hybrid numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 3

-- Tabs: Use spaces (more universal), and 4 spaces per "Tab".
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> counts for
vim.opt.softtabstop = 4 -- Number of spaces that a <Tab> counts for while performing editing
                        -- operations, like <BS>.
vim.opt.expandtab = true -- Use the appropriate number of spacces to insert a tab
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent, like >>

-- Show little glyphs for common whitespace gremlins
vim.opt.listchars = {
    tab      = '>·',
    trail    = '␠',
    nbsp     = '⎵',
    extends  = '→',
    precedes = '←'
}
vim.opt.list = true

-- Show a column at 80 characters
vim.opt.colorcolumn = "81"

-- Add full filename to statusline
vim.opt.statusline = vim.opt.statusline + "%F"

vim.opt.tags = "tags"


----------------------------------------------------
-- Custom keybindings
----------------------------------------------------
-- TODO: S-F11 to turn off search highlighting
-- TODO: <Leader>g in visual mode shows git blame

-- <Leader>ff shows telescope
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>gl', telescope.git_commits, {})
vim.keymap.set('n', '<leader>gd', telescope.git_bcommits, {})
vim.keymap.set('v', '<leader>gd', telescope.git_bcommits_range, {})



----------------------------------------------------
-- Colors and Ricing Configuration
----------------------------------------------------
vim.cmd.colorscheme("codedark")
