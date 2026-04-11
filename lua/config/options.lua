-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use project .venv if available, otherwise system python3
local function find_project_venv()
  local dir = vim.fn.getcwd()
  while dir ~= "/" do
    local venv = dir .. "/.venv/bin/python"
    if vim.fn.executable(venv) == 1 then
      return venv
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
end

local venv_python = find_project_venv()
if venv_python then
  vim.g.python3_host_prog = venv_python
end
