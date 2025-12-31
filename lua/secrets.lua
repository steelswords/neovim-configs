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

-- Check if pass is properly initialized
function M.is_initialized()
    return check_pass_installed() and exec_pass("ls") ~= nil
end

return M
