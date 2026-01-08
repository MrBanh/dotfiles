local ft = { "md", "markdown", "opencode_output" }

return {
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
      -- right_pad = 0,
      -- width = "block",
      -- language_border = " ",
      language_border = " ",
      language_right = "",
      sign = true,
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
}
