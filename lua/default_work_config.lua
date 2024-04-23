--------------------------------------------------------------------------------
-- Name:           default_work_config.lua
-- Author:         Tristan Andrus
-- Date of Origin: 22 April 2024
-- Description:    I don't like commiting work-related paths in my publically-
--                 accessible repos. So this is the prototype or template of a
--                 file that defines an object called `work_paths`. which has all
--                 of my work-related paths and data in it.
--
--                 TO USE:
--                 `cd lua && cp work_paths.lua my_work_paths.lua`
--                 Edit `my_work_paths.lua`. It's that simple. That file is already
--                 in the .gitignore.
--
--                 Documentation for pyright configs can be found
--                     for lspconfig: https://www.andersevenrud.net/neovim.github.io/lsp/configurations/pyright/#pythonvenvpath
--                     for pyright: https://microsoft.github.io/pyright/#/configuration?id=main-configuration-options
--------------------------------------------------------------------------------

return {
    pyright = {
        python = {
            analysis = {
                extraPaths = {},
            },
            venvPath = "",
        }
    }
}
