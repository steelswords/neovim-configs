--- File
--------------------------------------------------------------------------------
-- Name:           gitlab.lua
-- Author:         Tristan Andrus
-- Date of Origin: 26 March 2025
-- Description:    Integrates the gitlab.nvim plugin for work MRs, etc.
--------------------------------------------------------------------------------

require('diffview')
local gitlab_plugin = require("gitlab").setup({
    port = nil,
}) -- setup

--vim.api.nvim_create_user_command('MRReview', gitlab_plugin., {})
