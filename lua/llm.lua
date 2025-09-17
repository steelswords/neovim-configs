--------------------------------------------------------------------------------
-- Name:           ollama.lua
-- Author:         Tristan Andrus
-- Date of Origin: 3 Sep 2025
-- Description:    Ollama setup for local LLM completion
--------------------------------------------------------------------------------

local M = {}

local opt = {
    url = "http://127.0.0.1:11434",
    prompts = {
        Generate_Code = {
            --prompt = "Given you are working in the following source file: $buf\n\n, please answer as an expert, master programmer who never makes mistakes, always thinks things through thoroughly, and writes clear, bug-free, error-free, clean code, and $input",
            model = "codellama:7b",
        }
    }
}

function M.Get_Ollama_Handle()
    return require("ollama").setup(opt)
end

M.Get_Ollama_Handle()

return M
