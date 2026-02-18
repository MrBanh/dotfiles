local ft = { "md", "markdown", "opencode_output", "codecompanion" }

return {
  -- visual keybinds for markdown, C-b for bold, C-k for link, etc
  {
    "antonk52/markdowny.nvim",
    config = function()
      require("markdowny").setup()
    end,
  },
  {
    -- Lazy: https://www.lazyvim.org/extras/lang/markdown#render-markdownnvim
    "MeanderingProgrammer/render-markdown.nvim",
    lazy = true,
    ft = ft,
    opts = {
      -- Filetypes this plugin will run on.
      file_types = ft,
      heading = {
        icons = { "󰼏 ", "󰎨 ", "󰼑 ", "󰎲 ", "󰼓 ", "󰎴 " },
        position = "inline",
        width = "block",
        left_pad = 1,
        right_pad = 1,
      },
      html = {
        comment = {
          conceal = false,
        },
      },
      code = {
        language_border = "",
        language_right = "█",
        language_left = "█",
        border = "thin",
        above = "▄",
        below = "▀",
        sign = false,
      },
      checkbox = {
        enabled = true,
        custom = {
          todo = { raw = "[~]", rendered = "󰡖 ", highlight = "Orange", scope_highlight = "Orange" },
        },
        checked = {
          scope_highlight = "@markup.list.checked",
        },
        unchecked = {
          highlight = "Red",
          scope_highlight = "Red",
        },
      },
      bullet = {
        icons = { "○", "●" },
      },
      latex = {
        enabled = false,
      },
    },
  },
}
