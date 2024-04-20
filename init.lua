----------------------------------------------------
-- Setup
----------------------------------------------------
-- Packages to install:
--     silversearcher-ag
--     https://github.com/BurntSushi/ripgrep


----------------------------------------------------
-- Plugins
----------------------------------------------------
local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug("tomasiser/vim-code-dark")
Plug("nvim-lua/plenary.nvim") -- Required for telescope
Plug("nvim-telescope/telescope.nvim")

vim.call('plug#end')

----------------------------------------------------
-- LSP
----------------------------------------------------
-- My goal here is simple: I want the best features I can get, while minimizing
-- the complexity and number of modules, and while maximizing my understanding of
-- how it works so I can fix it when it breaks. To this end, I use the built-in
-- Neovim LSP.

-- TODO: These only work if I source this file, i.e. run this code twice.
--require('vim.lsp')

lsp_attach_callback = function(args)
    print("lsp attach 2")
    print("args 2 = ", args)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.hoverProvider then
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
    end

    -- Showing implementation
    if client.server_capabilities.implementationProvider then
        -- TODO: See if buffer args are needed.
        vim.keymap.set('n', 'ti', telescope.lsp_implementations, { buffer = args.buf })
    end
    if client.server_capabilities.definitionsProvider then
        vim.keymap.set('n', 'C-]', telescope.lsp_definitions)
        vim.keymap.set('n', 'td', telescope.lsp_definitions, { buffer = args.buf })
    end
    -- TODO: Wrap these in capabilities checking as welll
    vim.keymap.set('n', 't<F9>', telescope.lsp_outgoing_calls, { buffer = args.buf })
    vim.keymap.set('n', 't<F8>', telescope.lsp_incoming_calls, { buffer = args.buf })
end

-- Callback to set up LSP keybindings, depending on what capabilities are available.
lsp = require('vim.lsp')
vim.api.nvim_create_autocmd("LspAttach", {
    callback = lsp_attach_callback })

-- Start LSPs now that our callbacks are attached to the `LspAttach`
require('vim.lsp.log').set_format_func(vim.inspect)
if vim.fn.executable('clangd') then
    print("starting lsp")
    vim.lsp.start({
        name = 'clangd-lsp-server',
        cmd = {'/usr/bin/clangd'},
        root_dir = "." --TODO: Something clever here
    })
    print("started.")
end

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



