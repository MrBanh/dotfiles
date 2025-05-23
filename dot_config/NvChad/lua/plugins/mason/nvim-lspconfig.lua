return {
  "neovim/nvim-lspconfig",
  config = function()
    require("nvchad.configs.lspconfig").defaults()

    local servers = { "html", "cssls", "vtsls" }
    vim.lsp.enable(servers)

    vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    vim.keymap.set('n', '<space>cr', vim.lsp.buf.rename, {})
    -- vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, {}) -- handled by conform
  end,
}
