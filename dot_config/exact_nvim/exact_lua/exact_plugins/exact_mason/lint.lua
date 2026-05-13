local config = vim.fn.stdpath("config")
local rules = config .. "/lua/plugins/mason/rules/linters/"

return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = { "--config", rules .. ".markdownlint-cli2.yaml", "--" },
      },
    },
  },
}
