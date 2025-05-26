return {
  "stevearc/conform.nvim",
  event = 'BufWritePre', -- format on save
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      css = { "prettier" },
      html = { "prettier" },
    },

    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)

    vim.keymap.set({ "n", "x" }, "<leader>cf", function()
      require("conform").format { lsp_fallback = true }
    end, { desc = "Format file" })
  end
}
