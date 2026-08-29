return {
  "kylechui/nvim-surround",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  init = function()
    vim.g.nvim_surround_no_mappings = true -- :h nvim-surround.configuration 3.1, must be before plugin loads
  end,
  opts = {},
  keys = {
    {
      "gs",
      "<Plug>(nvim-surround-normal)",
      desc = "Add a surrounding pair around a motion (normal mode)",
      mode = "n",
    },
    {
      "gss",
      "<Plug>(nvim-surround-normal-cur)",
      desc = "Add a surrounding pair around the current line (normal mode)",
      mode = "n",
    },
    {
      "gs",
      "<Plug>(nvim-surround-visual)",
      desc = "Add a surrounding pair around a visual selection",
      mode = "x",
    },
    {
      "ds",
      "<Plug>(nvim-surround-delete)",
      desc = "Delete a surrounding pair",
      mode = "n",
    },
    {
      "cs",
      "<Plug>(nvim-surround-change)",
      desc = "Change a surrounding pair",
      mode = "n",
    },
  },
}
