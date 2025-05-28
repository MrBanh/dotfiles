return {
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
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
}
