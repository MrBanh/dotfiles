-- Lazy: https://www.lazyvim.org/extras/lang/markdown#render-markdownnvim
return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
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
    },
    checkbox = {
      enabled = true,
      custom = {
        todo = { raw = "[~]", rendered = " ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
      },
    },
  },
}
