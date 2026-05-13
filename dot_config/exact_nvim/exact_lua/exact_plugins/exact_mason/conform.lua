return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      zsh = { "shfmt" },
      sh = { "shfmt" },
    },
    formatters = {
      shfmt = {
        command = "shfmt",
        args = { "-i", "2", "-ci" },
        stdin = true,
      },
    },
  },
}
