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
    hooks = {
      ---@type fun()[]
      ["enter"] = {},

      ---@type fun(question: lc.ui.Question)[]
      ["question_enter"] = {
        function(q)
          local bufnr = q.bufnr
          vim.b[bufnr].copilot_enabled = false
          vim.keymap.set("n", "<localleader>d", "<Cmd>Leet desc<CR>", { buffer = bufnr, desc = "LeetCode description" })
          vim.keymap.set("n", "<localleader>h", "<Cmd>Leet hint<CR>", { buffer = bufnr, desc = "LeetCode hint" })
          vim.keymap.set("n", "<localleader>i", "<Cmd>Leet info<CR>", { buffer = bufnr, desc = "LeetCode information" })
          vim.keymap.set("n", "<localleader>l", "<Cmd>Leet list<CR>", { buffer = bufnr, desc = "LeetCode list" })
          vim.keymap.set("n", "<localleader>r", "<Cmd>Leet run<CR>", { buffer = bufnr, desc = "LeetCode run" })
          vim.keymap.set("n", "<localleader>s", "<Cmd>Leet submit<CR>", { buffer = bufnr, desc = "LeetCode submit" })
          vim.keymap.set("n", "<localleader>t", "<Cmd>Leet test<CR>", { buffer = bufnr, desc = "LeetCode test" })
        end,
      },

      ---@type fun()[]
      ["leave"] = {},
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
