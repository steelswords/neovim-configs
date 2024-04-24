--------------------------------------------------------------------------------
-- Name:           codeanalysis.lua
-- Author:         Tristan Andrus
-- Date of Origin: 21 April 2024
-- Description:    Neovim configs for LSPs and autocompletion stuff.
--------------------------------------------------------------------------------

----------------------------------------------------
-- LSP
----------------------------------------------------
-- My goal here is simple: I want the best features I can get, while minimizing
-- the complexity and number of modules, and while maximizing my understanding of
-- how it works so I can fix it when it breaks. To this end, I use the built-in
-- Neovim LSP with the neovim/nvim-lspconfig as a plugin.

local lsps_with_default_options = {
    "lua_ls",
    "bashls",
}
local lsps_with_tweaked_options = {
    "rust_analyzer",
    "pyright",
    "clangd",
}

local all_lsps = lsps_with_tweaked_options
for _, value in ipairs(lsps_with_default_options) do
    table.insert(all_lsps, value)
end


-- Install LSPs with mason
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = all_lsps,
    automatic_installation = true,
}

-- Wait until we start nvim-cmp to start LSPs.
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
        ['<C-space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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

-- Start LSPs
local lspconfig = require('lspconfig')

for _, item in ipairs(lsps_with_default_options)
do
    lspconfig[item].setup { capabilities = capabilities, }
end

-- Set up LSPs with tweaked options

Python_extra_paths = {}
Clangd_query_driver = ""

-- Project-specific configuration loading.
-- Overwrites `python_extra_paths` and `clangd_query_driver`
require("nvim-projectconfig").setup({
    project_dir = "/home/tristan/.config/nvim-projects-configs/"
})

-- print("Python extra paths = "..vim.inspect(Python_extra_paths))
-- print("Clangd query driver = "..vim.inspect(Clangd_query_driver))

lspconfig.rust_analyzer.setup{
    capabilities = capabilities,
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = false;
            }
        }
    }
}

lspconfig.pyright.setup {
    capabilities = capabilities,
    settings = {
        pyright = {
            autoImportCompletions = true,
        },
        python = {
            analysis = {
                diagnosticMode = "workspace",
                extraPaths = Python_extra_paths,
            },
        },
    },
}

-- TODO: Fix this so it's better
-- And more extensible. Maybe something like klen/nvim-config-local?
lspconfig.clangd.setup({
    cmd = {
        "clangd",
        "--pretty",
        "--log=verbose",
        "-j=20",
        "--header-insertion=iwyu",
        "--pch-storage=memory",
        "--clang-tidy",
        "--compile-commands-dir=.",
        Clangd_query_driver,
    },
    filetypes = { "c", "cpp", "h", "hpp", "cuda", "proto" },
})
