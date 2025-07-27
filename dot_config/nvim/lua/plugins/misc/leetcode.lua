return {
  "kawre/leetcode.nvim",
  cmd = "Leet",
  build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
  lazy = true,
  dependencies = {
    -- "nvim-telescope/telescope.nvim",
    -- "ibhagwan/fzf-lua",
    "folke/snacks.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    picker = { provider = nil },
    lang = "javascript",
    plugins = {
      non_standalone = true,
    },
    keys = {
      toggle = { "q" }, ---@type string|string[]
      confirm = { "<CR>" }, ---@type string|string[]
      reset_testcases = "r", ---@type string
      use_testcase = "U", ---@type string
      focus_testcases = "H", ---@type string
      focus_result = "L", ---@type string
    },
    -- image_support = true,
  },
}
