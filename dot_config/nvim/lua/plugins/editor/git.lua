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
        "",
        desc = "Open in browser",
        mode = { "n", "v" },
      },
      {
        "<leader>gob",
        function()
          Snacks.gitbrowse({
            what = "branch",
          })
        end,
        desc = "Git Open Branch",
        mode = { "n", "v" },
      },
      {
        "<leader>gof",
        function()
          Snacks.gitbrowse({
            what = "file",
          })
        end,
        desc = "Git Open File",
        mode = { "n", "v" },
      },
      {
        "<leader>gop",
        function()
          Snacks.gitbrowse({
            what = "permalink",
          })
        end,
        desc = "Git Open Permalink",
        mode = { "n", "v" },
      },
      {
        "<leader>goc",
        function()
          Snacks.gitbrowse({
            what = "commit",
          })
        end,
        desc = "Git Open Commit on cursor",
        mode = { "n", "v" },
      },
    },
  },
}
