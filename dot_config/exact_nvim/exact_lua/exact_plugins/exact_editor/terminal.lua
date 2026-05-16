return {
  "folke/snacks.nvim",
  opts = {
    terminal = {
      win = {
        style = vim.g.floating_terminal and {
          border = "rounded",
          position = "float",
          backdrop = 60,
          height = 0.6,
          width = 0.6,
          zindex = 50,
        } or "terminal",
      },
    },
  },
}
