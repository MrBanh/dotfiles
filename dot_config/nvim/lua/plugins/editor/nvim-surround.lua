return {
  "kylechui/nvim-surround",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  opts = {
    -- defaults: https://github.com/kylechui/nvim-surround/blob/main/lua/nvim-surround/config.lua
    keymaps = {
      normal = "gs",
      normal_cur = "gss",
      normal_line = "gS",
      normal_cur_line = "gSS",
      visual = "gs",
    },
  },
}
