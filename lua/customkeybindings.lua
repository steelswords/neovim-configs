--------------------------------------------------------------------------------
-- Name:           customkeybindings.lua
-- Author:         Tristan Andrus
-- Date of Origin: 21 April 2024
-- Description:    Defines custom keybindings.
--                 When you edit these, CHANGE "QUICK KEYBINDING REFERENCE" in
--                 init.lua!!
--------------------------------------------------------------------------------

----------------------------------------------------
-- Custom keybindings
----------------------------------------------------
-- TODO: S-F11 to turn off search highlighting
-- TODO: <Leader>g in visual mode to show git blame

-- <Leader>ff shows telescope
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fc', telescope.grep_string, {})
vim.keymap.set('n', '<leader>gl', telescope.git_commits, {})
vim.keymap.set('n', '<leader>gd', telescope.git_bcommits, {})
vim.keymap.set('v', '<leader>gd', telescope.git_bcommits_range, {})
vim.keymap.set('v', '<leader>gb', ":Git blame<CR>")

vim.keymap.set('n', 'gn', telescope.lsp_incoming_calls, {})
vim.keymap.set('n', 'gu', telescope.lsp_outgoing_calls, {})
vim.keymap.set('n', '<leader>fs', telescope.lsp_document_symbols, {})

-- Ultisnips
vim.g.UltiSnipsExpandTrigger="<C-j>"
vim.g.UltiSnipsJumpForwardTrigger="<C-J>"
vim.g.UltiSnipsJumpBackwardTrigger="<C-K>"

-- Misc
-- Add timestamp
vim.keymap.set('i', '<leader>ts', "<C-R>=strftime('%c')<CR>", {remap= true})


