return {
  "catppuccin/nvim",
  enabled = false,
  name = "catppuccin",
  lazy = true,
  priority = 1000, -- make sure to load this before all the other start plugins
  opts = {
    flavour = "mocha",
    transparent_background = true,
    integrations = {
      blink_cmp = true,
      snacks = true,
    },
  },
}
