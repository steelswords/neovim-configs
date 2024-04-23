local loadworkconfig = {}

_G.vim = vim

function loadworkconfig.GetWorkPaths()
    local DEFAULT_FILE_NAME = vim.fn.stdpath('config').."/lua/default_work_config.lua"
    local CUSTOM_FILE_NAME  = vim.fn.stdpath('config').."/lua/my_work_config.lua"

    local work_paths = {}
    local custom_work_paths = loadfile(CUSTOM_FILE_NAME)
    local default_work_paths = loadfile(DEFAULT_FILE_NAME)
    if custom_work_paths then
        work_paths = custom_work_paths()
    elseif default_work_paths then
        work_paths = default_work_paths()
    else
        print("ERROR! Missing "..DEFAULT_FILE_NAME)
    end
    return work_paths
end

return loadworkconfig
