vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
vim.keymap.set("n", "<leader>cr", require "nvchad.lsp.renamer", { desc = "LSP NvRenamer" })
vim.keymap.set("n", "<leader>cw", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
vim.keymap.set("n", "<leader>cW", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
-- vim.keymap.set("n", "K", function()
--   vim.lsp.buf.hover { border = "rounded" }
-- end, { desc = "LSP show details", silent = true })
-- vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { desc = "Rename" })
-- vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, {}) -- handled by conform

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
    end,
  },
}
