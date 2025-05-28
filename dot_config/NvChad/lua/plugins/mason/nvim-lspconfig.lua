return {
  "neovim/nvim-lspconfig",
  config = function()
    require("nvchad.configs.lspconfig").defaults()

    local servers = { "html", "cssls" }
    vim.lsp.enable(servers)

    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover { border = "rounded" }
    end, { desc = "LSP show details", silent = true })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, {})
    -- vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, {}) -- handled by conform
  end,
}
