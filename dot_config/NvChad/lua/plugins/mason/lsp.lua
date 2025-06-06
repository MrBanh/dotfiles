return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_enable = true,
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    event = { "VeryLazy", "BufRead" },
    config = function()
      require("nvchad.configs.lspconfig").defaults()

      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
      vim.keymap.set("n", "<leader>cr", require "nvchad.lsp.renamer", { desc = "LSP NvRenamer" })

      -- vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { desc = "Rename" })
      -- vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, {}) -- handled by conform
    end,
  },
}
