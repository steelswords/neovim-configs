-- pass.lua - Secure interface to the pass password manager
-- Requires: pass (https://www.passwordstore.org/)

local M = {}

-- Check if pass is installed
local function check_pass_installed()
    local handle = io.popen("command -v pass 2>/dev/null")
    local result = handle:read("*a")
    handle:close()
    return result and result ~= ""
end

-- Escape shell arguments to prevent injection
local function escape_arg(arg)
    if not arg then return "" end
    -- Replace single quotes with '\'' (end quote, escaped quote, start quote)
    return "'" .. arg:gsub("'", "'\\''") .. "'"
end

-- Execute pass command and capture output
local function exec_pass(args, capture_stderr)
    local cmd = "pass " .. args
    if capture_stderr then
        cmd = cmd .. " 2>&1"
    else
        cmd = cmd .. " 2>/dev/null"
    end
    
    local handle = io.popen(cmd)
    if not handle then
        return nil, "Failed to execute pass command"
    end
    
    local result = handle:read("*a")
    local success, exit_type, code = handle:close()
    
    if not success then
        return nil, "Pass command failed with exit code: " .. tostring(code)
    end
    
    return result
end

-- Get a password from pass
-- @param path string: The path to the password in the store
-- @return string|nil, string|nil: The password or nil, error message
function M.get(path)
    if not path or path == "" then
        return nil, "Password path cannot be empty"
    end
    
    if not check_pass_installed() then
        return nil, "pass is not installed or not in PATH"
    end
    
    local result, err = exec_pass(escape_arg(path))
    
    if not result then
        return nil, err
    end
    
    -- Remove trailing newline if present
    result = result:gsub("\n$", "")
    
    if result == "" then
        return nil, "Password not found or empty"
    end
    
    return result
end

-- Get password and additional metadata
-- @param path string: The path to the password in the store
-- @return table|nil, string|nil: Table with password and lines, or nil and error
function M.get_full(path)
    if not path or path == "" then
        return nil, "Password path cannot be empty"
    end
    
    if not check_pass_installed() then
        return nil, "pass is not installed or not in PATH"
    end
    
    local result, err = exec_pass(escape_arg(path))
    
    if not result then
        return nil, err
    end
    
    local lines = {}
    local password = nil
    
    for line in result:gmatch("[^\n]+") do
        if not password then
            password = line
        else
            table.insert(lines, line)
        end
    end
    
    if not password then
        return nil, "Password not found or empty"
    end
    
    return {
        password = password,
        metadata = lines
    }
end

-- List passwords in the store
-- @param subfolder string|nil: Optional subfolder to list
-- @return table|nil, string|nil: Array of password paths or nil, error message
function M.list(subfolder)
    if not check_pass_installed() then
        return nil, "pass is not installed or not in PATH"
    end
    
    local args = "ls"
    if subfolder and subfolder ~= "" then
        args = args .. " " .. escape_arg(subfolder)
    end
    
    local result, err = exec_pass(args)
    
    if not result then
        return nil, err
    end
    
    local paths = {}
    for line in result:gmatch("[^\n]+") do
        -- Extract password names (lines that don't start with directory indicators)
        local path = line:match("^[├└│ ]*([^/]+)$")
        if path and not path:match("^Password Store$") then
            table.insert(paths, path)
        end
    end
    
    return paths
end

-- Search for passwords
-- @param query string: Search term
-- @return table|nil, string|nil: Array of matching paths or nil, error message
function M.search(query)
    if not query or query == "" then
        return nil, "Search query cannot be empty"
    end
    
    if not check_pass_installed() then
        return nil, "pass is not installed or not in PATH"
    end
    
    local result, err = exec_pass("find " .. escape_arg(query))
    
    if not result then
        return nil, err
    end
    
    local matches = {}
    for line in result:gmatch("[^\n]+") do
        if line ~= "" and not line:match("^Search") then
            table.insert(matches, line)
        end
    end
    
    return matches
end

-- Generate a new password
-- @param path string: Path where to store the password
-- @param length number: Length of password (default: 25)
-- @param no_symbols boolean: Exclude symbols (default: false)
-- @return boolean, string|nil: Success status, error message if failed
function M.generate(path, length, no_symbols)
    if not path or path == "" then
        return false, "Password path cannot be empty"
    end
    
    if not check_pass_installed() then
        return false, "pass is not installed or not in PATH"
    end
    
    length = length or 25
    local args = "generate " .. (no_symbols and "-n " or "") .. escape_arg(path) .. " " .. tostring(length)
    
    local result, err = exec_pass(args, true)
    
    if not result then
        return false, err
    end
    
    return true
end

-- Check if pass is properly initialized
function M.is_initialized()
    return check_pass_installed() and exec_pass("ls") ~= nil
end

return M
