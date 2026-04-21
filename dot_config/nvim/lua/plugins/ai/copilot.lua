local disabled_filetypes = {
  "markdown",
}

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      copilot = {
        on_attach = function(client, bufnr)
          local ft = vim.bo[bufnr].filetype
          if vim.tbl_contains(disabled_filetypes, ft) then
            vim.schedule(function()
              vim.lsp.buf_detach_client(bufnr, client.id)
            end)
          end
        end,
      },
    },
  },
}
