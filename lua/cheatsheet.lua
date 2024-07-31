--------------------------------------------------------------------------------
-- Name:           cheatsheet.lua
-- Author:         Tristan Andrus
-- Date of Origin: 29 May 2024
-- Description:    Makes a popup window with my custom keybindings in it
--------------------------------------------------------------------------------

local function show_scrollable_popup()
  local lines = {
    "==================================================",
    " QUICK KEYBINDING REFERENCE",
    "==================================================",
    " \\ff   Telescope find find_files",
    " \\fg   Telescope live grep through CWD and children",
    " \\fc   Telescope live grep through CWD and children for word under cursor",
    " \\gl   Telescope show git commits",
    " \\gd   Show buffer's git history in git commits ",
    " C-j   Expand Ultisnips snippet",
    "",
    "            LSP stuff:",
    " <space>e Open float of diagnostics",
    " [d       goto previous diagnostic",
    " ]d       goto next diagnostic",
    " <space>q  vim.diagnostic.setloclist",
    " gD       goto declaration",
    " gd       goto definition",
    " \\fs     Show symbols in current buffer",
    "",
    " K        show documentation",
    " gi       goto implementation",
    " C-k      signature help",
    " <space>D  workspace definition",
    " <space>rn  buffer rename",
    " <space>ca  do code action",
    " gr         show references to buffer",
    " C-h        switch between header and source in cpp",
    " C-e        abort autocomplete",
    " C-b        scroll autocomplete docs",
    " C-f        scroll autocomplete docs",
    " C-<space>  autocomplete complete",
    " <CR>       autocomplete confirm",
    "",
    " gn Show incoming calls in telescope",
    " gu Show outgoing calls in telescope",
    "",
    " <leader>ts Insert timestamp in Insert mode",
    "",
  }

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Set buffer lines
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Get the dimensions of the current Neovim window
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  -- Define the popup window dimensions
  local win_width = math.ceil(width * 0.5)
  local win_height = math.ceil(height * 0.5)

  -- Define the window options
  local opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = math.ceil((height - win_height) / 2),
    col = math.ceil((width - win_width) / 2),
    border = "single",
  }

  -- Create a new floating window
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set options for the buffer
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'swapfile', false)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  -- Set key mappings for scrolling
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Down>', '<C-e>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Up>', '<C-y>', { noremap = true, silent = true })

  -- Set key mappings to close the window
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
end

-- Make the function available as a command
vim.api.nvim_create_user_command('ShowKeybindings', show_scrollable_popup, {})
vim.api.nvim_create_user_command('Cheatsheet', show_scrollable_popup, {})
vim.keymap.set('n', '<leader>?', show_scrollable_popup, {})
