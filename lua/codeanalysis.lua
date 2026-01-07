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
    "biome",
}
local lsps_with_tweaked_options = {
    --"rust_analyzer",
    "pyright",
    "clangd",
}

local all_lsps = lsps_with_tweaked_options
for _, value in ipairs(lsps_with_default_options) do
    table.insert(all_lsps, value)
end



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

-- Only run Copilot on my work laptop.
local hostname = vim.fn.hostname()
if hostname == "vivint-laptop" then
    -- LLMs really do not know what they're doing half the time.
    -- The best way I ever got this to work was to just leave Copilot disabled
    -- by default, and run ":Copilot enable" when I want some LLM action.
    -- Then I use the default tab completion and run ":Copilot disable" when I'm
    -- done. 🤷

    -- Set up Github copilot keybindings
    --vim.g.copilot_no_tab_map = true

    -- Disable suggestions automatically, since they hurt my flow.
    --vim.g.copilot.set_config({
    --    suggestion = { enabled = false },
    --    panel = { enabled = false },
    --})

    vim.g.copilot_enabled = false
    --
    --
    --vim.keymap.set("i", "<C-CR>", vim.fn['copilot#Accept("<CR>")'], { expr = true, replace_keycodes=false })
    --vim.keymap.set("i", "<C-g>", vim.fn["copilot#Suggest"],  { expr=true })
    --vim.keymap.set("i", "<C-/>", 'copilot#Previous()', { silent = true, expr = true })
    --vim.keymap.set("i", "<C-?>", 'copilot#Next()', { silent = true, expr = true })
    --vim.keymap.set("i", "<C-X>", 'copilot#Dismiss()', { silent = true, expr = true })
    --
end

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
        ['<tab>'] = cmp.mapping.select_next_item(),
        ['<S-tab>'] = cmp.mapping.select_prev_item(),
        ['<C-space>'] = cmp.mapping.complete(), -- i.e. trigger complettion
        ['<C-q>'] = cmp.mapping.abort(),
        --['<C-CR>'] = cmp.mapping.confirm({select = true}),
        -- Appropriating this for Github Copilot
        ['<C-j'] = cmp.mapping.confirm({select = true}),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        --['<tab>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        --
        -- From https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/:
        -- If the completion menu is visible, move to the next item. If the line is
        -- "empty", insert a Tab character. If the cursor is inside a word,
        -- trigger the completion menu.
        --['<Tab>'] = cmp.mapping(function(fallback)
        --    local col = vim.fn.col('.') - 1

        --    if cmp.visible() then
        --        cmp.select_next_item(select_opts)
        --    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        --        fallback()
        --    else
        --        cmp.complete()
        --    end
        --end, {'i', 's'}),

        --['<S-Tab>'] = cmp.mapping(function(fallback)
        --    if cmp.visible() then
        --        cmp.select_prev_item(select_opts)
        --    else
        --        fallback()
        --    end
        --end, {'i', 's'}),

    }),
    sources = cmp.config.sources({
        { name = 'ultisnips' }, -- For ultisnips users.
        { name = 'buffer' },
        { name = 'path' },
        { name = 'nvim_lsp' },
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
    sources = cmp.config.sources(
    { { name = 'path' } },
    { { name = 'buffer' } },
    { { name = 'cmdline' } }
    ),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Start LSPs

-- Set up LSPs with tweaked options
Python_extra_paths = {}

-- Project-specific configuration loading.
-- Overwrites `python_extra_paths` and `Clangd_query_driver`
require("nvim-projectconfig").setup({
    project_dir = "/home/tristan/.config/nvim-projects-configs/"
})

-- Install LSPs with mason
require("mason").setup()
local handlers = {
    -- Default handler. Sets up all the LSPs with default options.
    function (server_name)
        vim.lsp.config[server_name].setup {}
    end,
-- rustaceanvim requires us not to set this up through nvim-lspconfig
--    ["rust_analyzer"] = function ()
--        lspconfig.rust_analyzer.setup {
--            capabilities = capabilities,
--            settings = {
--                ['rust-analyzer'] = {
--                    --diagnostics.enable = true
--                    --diagnostics = {
--                    --    enable = true;
--                    --},
--                    --completion = {
--                    --    autoimport {
--                    --        enable = true
--                    --    },
--                    --    autoself {
--                    --        enable = true
--                    --    }
--                    --}
--                }
--            }
--        }
--    end,

    ["pyright"] = function ()
        vim.lsp.config['pyright'].setup {
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
    end,

    ["clangd"] = function()
        vim.lsp.config['clangd'].setup({
            capabilities = capabilities,
            cmd = {
                "clangd",
                "--pretty",
                "--log=verbose",
                "-j=20",
                "--header-insertion=iwyu",
                "--offset-encoding=utf-16",
                "--pch-storage=memory",
                "--clang-tidy",
                "--compile-commands-dir=.",
                "--enable-config",
            },
            filetypes = { "c", "cpp", "h", "hpp", "cuda", "proto" },
        })
    end,
}
require("mason-lspconfig").setup({
    ensure_installed = all_lsps,
    automatic_installation = true,
    handlers = handlers,
})

-- This plugin gives me header/source switching and some other goodies that aren't
-- standard in the clangd lsp.
require("clangd_extensions")

--vim.lsp.config['qmlls'].setup( { })
-- Rusttools requires something


-- Stop all the ridiculous logging from LSP. This thing starts to take up gigabytes
vim.lsp.set_log_level("ERROR")
