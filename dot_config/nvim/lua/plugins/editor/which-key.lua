return {
  "folke/which-key.nvim",
  lazy = false,
  opts = {
    preset = "classic",
  },

  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      "<leader>a",
      group = "ai",
    })
  end,
}
