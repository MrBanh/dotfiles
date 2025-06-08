return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>c", group = "Code", icon = { icon = "󱐌 " } },
        { "[", group = "Prev" },
        { "]", group = "Next" },
        { "g", group = "Go to..." },
        { "z", group = "Fold" },
        {
          "<leader>b",
          group = "Buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "Windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show { global = false }
      end,
      desc = "Buffer Keymaps (which-key)",
    },
  },
}
