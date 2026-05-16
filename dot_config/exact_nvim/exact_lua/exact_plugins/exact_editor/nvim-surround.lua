return {
  "kylechui/nvim-surround",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
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
      "gS",
      "<Plug>(nvim-surround-normal-line)",
      desc = "Add a surrounding pair around a motion, on new lines (normal mode)",
      mode = "n",
    },
    {
      "gSS",
      "<Plug>(nvim-surround-normal-cur-line)",
      desc = "Add a surrounding pair around the current line, on new lines (normal mode)",
      mode = "n",
    },
    {
      "gs",
      "<Plug>(nvim-surround-visual)",
      desc = "Add a surrounding pair around a visual selection",
      mode = "x",
    },
  },
}
