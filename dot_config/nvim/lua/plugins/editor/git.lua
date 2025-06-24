return {
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      -- if I need to override keys: https://github.com/LazyVim/LazyVim/discussions/4790
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)

      Snacks.toggle({
        name = "Git Inline Blame",
        get = function()
          return require("gitsigns.config").config.current_line_blame
        end,
        set = function()
          require("gitsigns").toggle_current_line_blame()
        end,
      }):map("<leader>uB")
    end,
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>go",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Open in Browser",
        mode = { "n", "v" },
      },
      {
        "<leader>gB",
        nil,
        mode = { "n", "v" },
      },
    },
  },
}
