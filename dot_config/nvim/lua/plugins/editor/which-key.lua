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
      {
        "<leader>N",
        group = "News...",
        icon = { icon = "󰅸 " },
      },
      {
        "<leader>S",
        group = "scratch",
        icon = { icon = " " },
      },
    })
  end,
}
