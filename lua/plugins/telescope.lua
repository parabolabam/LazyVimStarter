return {
  {
    "telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
          require("telescope").load_extension("projects")
        end,
      },

      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        version = "^1.0.0",
        config = function()
          require("telescope").load_extension("live_grep_args")
        end,
      },
    },

    config = function()
      local telescopeConfig = require("telescope.config")

      -- Clone the default Telescope configuration
      local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

      -- I want to search in hidden/dot files.
      table.insert(vimgrep_arguments, "--hidden")
      -- I don't want to search in the `.git` directory.
      table.insert(vimgrep_arguments, "--glob")
      table.insert(vimgrep_arguments, "!**/.git/*")
      require("telescope").setup({
        defaults = {
          path_display = {
            "filename_first",
          },
          -- `hidden = true` is not supported in text grep commands.
          vimgrep_arguments = vimgrep_arguments,
        },

        pickers = {
          find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
            theme = "dropdown",
          },
          find_word = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
            theme = "dropdown",
          },
          git_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            theme = "dropdown",
          },
        },
      })
    end,
  },
}
