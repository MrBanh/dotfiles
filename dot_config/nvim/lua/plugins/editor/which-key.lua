return {
  "folke/which-key.nvim",
  lazy = false,
  opts = {
    preset = "classic",

    --- * local: buffer-local mappings first
    --- * order: order of the items (Used by plugins like marks / registers)
    --- * group: groups last
    --- * alphanum: alpha-numerical first
    --- * mod: special modifier keys last
    --- * manual: the order the mappings were added
    --- * case: lower-case first
    sort = { "order", "alphanum", "mod" },
  },

  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      {
        "<leader>N",
        group = "news...",
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
