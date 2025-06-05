return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
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
    checkbox = {
      enabled = true,
      custom = {
        todo = { raw = "[~]", rendered = " ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
      },
    },
  },
  ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
  config = function(_, opts)
    dofile(vim.g.base46_cache .. "render-markdown")
    require("render-markdown").setup(opts)
  end,
}
