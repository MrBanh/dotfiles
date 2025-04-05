return {
  {
    "mfussenegger/nvim-lint",
    event = "LazyFile",
    opts = {
      linters = {
        markdownlint = {
          args = { "--disable", "MD013", "--" },
        },
      },
    },
  },
}
