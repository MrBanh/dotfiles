return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = {
          "--config",
          os.getenv("HOME") .. "/.config/nvim/lua/plugins/mason/rules/linters/markdownlint-cli2.yaml",
          "--",
        },
      },
    },
  },
}
