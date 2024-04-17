-- Author: Tristan Andrus
-- Description: Awesome developer goodies; utilities to deploy things to Vivint panels.
-- Date: 21 Feb 2024
--
-- TODOs:
-- [ ] Make this a plugin
-- [ ] Save config to somewhere nicer

cached_target_panel='default'
config_file_path = vim.fn.stdpath('config') .. '/targetpanel.config'
python_script_file_path = '~/Applications/work-scripts/deploypy.py'

hello_world = function(opts)
    print("Hello, world!")
    print("And hello, ", opts.args)
    if opts.bang
    then
        print("Bang, bang!")
    end
end

set_target_panel = function(opts)
    if opts.args and opts.args ~= '' then
        deploy_panel = opts.args
        print("Setting default panel to ", deploy_panel)
        cached_target_panel = deploy_panel
        local config_file = io.open(config_file_path, 'w')
        config_file:write(deploy_panel)
        config_file:close()
        print("Persisted to config")
    else
        print("Panel not set. Please provide a valid name")
    end
end

function get_target_panel()
    if cached_target_panel == "default" then
        print("Target panel == 'default', checking config.")
        local config_file = io.open(config_file_path, 'r')
        if config_file then
            local name = config_file:read('*line')
            config_file:close()
            if name and name ~= '' then
                cached_target_panel = name
                return name
            end
        end
    else
        return cached_target_panel
    end
    -- If we're here, we've fallen out of all the happy paths.
    -- target_name is not set up.
    print("This may be the first time you have used this plugin.")
    local name = ''
    repeat
        name = vim.fn.input('Please enter the SSH target of the panel you want to deploy to: ')
    until (name ~= '')
    cached_target_panel = name
    return cached_target_panel
end

on_deploy_exit = function(obj)
    print("Done deploying. Output:")
    print(obj.code)
    print(obj.signal)
    print(obj.stdout)
    print(obj.stderr)
end

deploy_python = function(opts)
    target = get_target_panel()
    print("Deploying ", vim.api.nvim_buf_get_name(0))
    print(" to ", target)
    local file_name = vim.api.nvim_buf_get_name(0)
    local result_obj = vim.system({'python3',
        '/home/tristan/Applications/work-scripts/deploypy.py',
        '--target',
        target,
        file_name},
        {text = true}
    ):wait()
    on_deploy_exit(result_obj)
end

vim.api.nvim_create_user_command(
    'HelloWorld',
    hello_world,
    {nargs=1, bang=false}
)

-- TODO: Add a GetTargetPanel command

vim.api.nvim_create_user_command(
    'SetTargetPanel',
    set_target_panel,
    {nargs=1}
)

vim.api.nvim_create_user_command(
    'DeployPythonToPanel',
    deploy_python,
    {nargs=0}
)
