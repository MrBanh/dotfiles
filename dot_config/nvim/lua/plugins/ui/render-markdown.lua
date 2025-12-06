local ft = { "markdown", "opencode_output" }

-- Lazy: https://www.lazyvim.org/extras/lang/markdown#render-markdownnvim
return {
  "MeanderingProgrammer/render-markdown.nvim",
  lazy = true,
  ft = ft,
  opts = {
    -- Filetypes this plugin will run on.
    file_types = ft,
    heading = {
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      position = "inline",
      width = "block",
      left_pad = 2,
      right_pad = 2,
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
    },
    checkbox = {
      enabled = true,
      custom = {
        todo = { raw = "[~]", rendered = " ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
      },
    },
    latex = {
      enabled = false,
    },
  },
}
