return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            hover = {
              previewFields = 200, -- default 50; raise to show more struct fields
              enumsLimit = 100, -- default 5; for large union/enum types
            },
          },
        },
      },
      vtsls = {
        keys = {
          {
            "<leader>cu",
            LazyVim.lsp.action["source.removeUnused.ts"],
            desc = "Remove unused",
          },
        },
      },
    },
  },
}
