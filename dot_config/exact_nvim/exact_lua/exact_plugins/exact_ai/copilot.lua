local disabled_filetypes = {
  "markdown",
}

local function dismiss()
  vim.lsp.inline_completion.enable(false, { bufnr = 0 })
  vim.lsp.inline_completion.enable(true, { bufnr = 0 })
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      copilot = {
        settings = {
          telemetry = {
            telemetryLevel = "off",
          },
        },
        on_attach = function(client, bufnr)
          local ft = vim.bo[bufnr].filetype
          if vim.tbl_contains(disabled_filetypes, ft) then
            vim.schedule(function()
              vim.lsp.buf_detach_client(bufnr, client.id)
            end)
          end
        end,
        keys = {
          {
            "<C-e>",
            dismiss,
            mode = "i",
            desc = "Dismiss Copilot suggestion",
          },
          {
            "<C-c>",
            dismiss,
            mode = "i",
            desc = "Dismiss Copilot suggestion",
          },
        },
      },
    },
  },
}
