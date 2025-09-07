return {
  "suliatis/Jumppack.nvim",
  event = "VeryLazy",
  opts = {
    window = {
      config = function()
        local height = math.floor(vim.o.lines * 0.6)
        local width = math.floor(vim.o.columns * 0.6)
        return {
          relative = "editor",
          row = math.floor((vim.o.lines - height) * 2), -- for some reason *2 centers it vertically
          col = math.floor((vim.o.columns - width) / 2),
          width = width,
          height = height,
          border = "rounded",
          title = " Jumplist ",
          title_pos = "center",
        }
      end,
    },
  },
}
