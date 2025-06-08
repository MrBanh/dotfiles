return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters = {
      ["markdownlint-cli2"] = {
        args = {
          "--config",
          os.getenv "HOME" .. "/.config/NvChad/lua/plugins/mason/rules/linters/markdownlint-cli2.yaml",
          "--",
        },
      },
    },
  },
}
