return {
  "folke/todo-comments.nvim",
  opts = {
    highlight = {
      pattern = { [[.*<(KEYWORDS)\s*:]], [[.*<(KEYWORDS)\s*-]], [[.*<(KEYWORDS) ]] },
    },
    search = {
      pattern = [[\s+(KEYWORDS)\b]],
    },
  },
}
