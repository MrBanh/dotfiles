return {
  "folke/snacks.nvim",
  opts = {
    bigfile = {},
    image = {},
    ---@class snacks.input.Config
    input = {
      win = {
        b = {
          completion = true, -- blink completions in input
        },
      },
    },
    scroll = {
      enabled = false,
    },
  },
}
