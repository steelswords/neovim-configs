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

-- Git decorations with gitsigns
require('gitsigns').setup()

----------------------------------------------------
-- Colors and Ricing Configuration
----------------------------------------------------
vim.cmd.colorscheme("codedark")
