return {
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = function()
      return {
        current_line_blame = true,
      }
    end,
  },
  { "tpope/vim-fugitive" },
}
