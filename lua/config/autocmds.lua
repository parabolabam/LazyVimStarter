-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Jupyter notebook workflow
local jupyter_group = vim.api.nvim_create_augroup("jupyter_notebook", { clear = true })

-- Disable swap files for .ipynb to prevent E325 in jupytext callback
vim.api.nvim_create_autocmd("BufReadCmd", {
  group = jupyter_group,
  pattern = "*.ipynb",
  callback = function()
    vim.bo.swapfile = false
  end,
})

-- Show fences and set cwd to notebook directory for correct relative paths
vim.api.nvim_create_autocmd("BufEnter", {
  group = jupyter_group,
  pattern = "*.ipynb",
  callback = function(e)
    vim.wo.conceallevel = 0
    local dir = vim.fn.fnamemodify(e.file, ":p:h")
    vim.cmd.lcd(dir)
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = jupyter_group,
  pattern = { "*.md", "*.ju.py" },
  callback = function(e)
    local ipynb = vim.fn.fnamemodify(e.file, ":r") .. ".ipynb"
    if vim.fn.filereadable(ipynb) == 1 then
      vim.schedule(function()
        pcall(vim.cmd, "MoltenImportOutput")
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = jupyter_group,
  pattern = { "*.md", "*.ju.py" },
  callback = function()
    if vim.b.molten_active_kernel then
      pcall(vim.cmd, "MoltenExportOutput!")
    end
  end,
})
