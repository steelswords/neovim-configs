--------------------------------------------------------------------------------
-- Name:           ollama.lua
-- Author:         Tristan Andrus
-- Date of Origin: 3 Sep 2025
-- Description:    Ollama setup for local LLM completion
--------------------------------------------------------------------------------

local M = {}



local function is_work_computer()
    local hostname = vim.fn.hostname()
    local work_hostnames = { "vivint-laptop" }
    return vim.tbl_contains(work_hostnames, hostname)
end

function M.Get_Ollama_Handle()
    local ollama_opts = {
        url = "http://127.0.0.1:11434",
        prompts = {
            Generate_Code = {
                --prompt = "Given you are working in the following source file: $buf\n\n, please answer as an expert, master programmer who never makes mistakes, always thinks things through thoroughly, and writes clear, bug-free, error-free, clean code, and $input",
                model = "codellama:7b",
            }
        }
    }
    return require("ollama").setup(ollama_opts)
end

M.Get_Ollama_Handle()

require('img-clip').setup({})

-- Copilot
require('copilot').setup({
    suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
            accept = "<C-g>",
            accept_word = false,
            accept_line = false,
            next = "<C-Tab>",
            prev = "<C-S-Tab>",
        },
    }
})
local function toggle_copilot()
    local suggestions = require('copilot.suggestion')
    if suggestions.auto_trigger then
        print("Copilot suggestions disabled")
    else
        print("Copilot suggestions enabled")
    end
    suggestions.toggle_auto_trigger()
end
vim.keymap.set('n', '<leader>c', toggle_copilot, {})

require('render-markdown').setup({
    opts = {
        file_types = { "markdown", "Avante" },
    },
    ft = { "markdown", "Avante" },
})


-- Providers are dependent on what computer I'm on. Home computers get home models.
-- Work computers get work models
local function get_home_or_work_providers()
    -- Get hostname
    if is_work_computer() then
        -- Work providers
        return {
            copilot = {},
            ollama = {
                -- model = "qwen2.5-coder:3b",
            },

        }
    else
        -- Home providers
        return {
            ollama = {
                model = "qwen2.5-coder:3b",
            },
            claude = {
                endpoint = "https://api.anthropic.com",
                model = "claude-sonnet-4.5",
                timeout = 30000, -- Timeout in milliseconds
                  extra_request_body = {
                    temperature = 0.75,
                    max_tokens = 20480,
                  },
            },
        }
    end
end

require('avante').setup({
    auto_suggestions_provider = "ollama",
    provider = "ollama",
    providers = get_home_or_work_providers(),
    rag_service = {
        enabled = false,
        host_mount = vim.fn.expand("."),
        llm = {
            provider = "ollama",
        }
    },
})

return M
