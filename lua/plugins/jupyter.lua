return {
  -- image.nvim: inline image rendering in terminal
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown" },
        },
      },
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },

  -- molten-nvim: Jupyter kernel execution engine
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_auto_open_output = false
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 40
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_auto_init_behavior = "init"
      vim.g.molten_enter_output_behavior = "open_and_enter"
      vim.g.molten_output_show_more = true
    end,
    keys = {
      -- Kernel
      {
        "<leader>ji",
        function()
          -- Auto-init with python3, notify with notebook name
          local name = vim.fn.expand("%:t:r") -- e.g. "AI-1724_metrics_part1"
          vim.cmd("MoltenInit python3")
          vim.notify("Kernel started for: " .. name, vim.log.levels.INFO)
        end,
        desc = "Init Kernel",
      },
      { "<leader>jd", "<cmd>MoltenDeinit<CR>", desc = "Deinit Kernel" },
      { "<leader>jI", "<cmd>MoltenInfo<CR>", desc = "Kernel Info" },

      -- Evaluate
      {
        "<leader>je",
        function()
          local row = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          local start_row, end_row
          -- Search upward for opening ``` (with optional language tag)
          for i = row, 1, -1 do
            local trimmed = vim.trim(lines[i])
            if trimmed:match("^```%w") then
              start_row = i + 1
              break
            elseif trimmed:match("^```%s*$") and i < row then
              break
            end
          end
          -- Search downward for closing ```
          if start_row then
            for i = start_row, #lines do
              local trimmed = vim.trim(lines[i])
              if trimmed:match("^```%s*$") then
                end_row = i - 1
                break
              end
            end
          end
          if start_row and end_row and start_row <= end_row then
            vim.fn.setpos("'<", { 0, start_row, 1, 0 })
            vim.fn.setpos("'>", { 0, end_row, #lines[end_row], 0 })
            vim.cmd("MoltenEvaluateVisual")
          else
            vim.notify("Not inside a code block", vim.log.levels.WARN)
          end
        end,
        desc = "Evaluate Cell",
      },
      { "<leader>jl", "<cmd>MoltenEvaluateLine<CR>", desc = "Evaluate Line" },
      { "<leader>je", ":<C-u>MoltenEvaluateVisual<CR>gv", mode = "v", desc = "Evaluate Visual" },
      { "<leader>jr", "<cmd>MoltenReevaluateCell<CR>", desc = "Re-evaluate Cell" },
      { "<leader>jR", "<cmd>MoltenReevaluateAll<CR>", desc = "Re-evaluate All" },

      -- Output
      { "<leader>jo", "<cmd>noautocmd MoltenEnterOutput<CR>", desc = "Enter Output" },
      { "<leader>jh", "<cmd>MoltenHideOutput<CR>", desc = "Hide Output" },
      { "<leader>jx", "<cmd>MoltenDelete<CR>", desc = "Delete Cell" },

      -- Navigation
      { "<leader>jn", "<cmd>MoltenNext<CR>", desc = "Next Cell" },
      { "<leader>jp", "<cmd>MoltenPrev<CR>", desc = "Prev Cell" },

      -- Notebook I/O
      { "<leader>js", "<cmd>MoltenSave<CR>", desc = "Save Cell State" },
      { "<leader>jL", "<cmd>MoltenLoad<CR>", desc = "Load Cell State" },
      { "<leader>jE", "<cmd>MoltenExportOutput!<CR>", desc = "Export to ipynb" },
      { "<leader>jO", "<cmd>MoltenImportOutput<CR>", desc = "Import from ipynb" },
    },
  },

  -- jupytext.nvim: transparent .ipynb <-> plaintext conversion
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
      custom_language_formatting = {},
    },
  },

  -- otter.nvim: LSP in embedded code blocks (markdown/quarto)
  {
    "jmbuhr/otter.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },

  -- Treesitter: ensure parsers needed for notebook support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "python",
        "markdown",
        "markdown_inline",
        "latex",
      },
    },
  },
}
