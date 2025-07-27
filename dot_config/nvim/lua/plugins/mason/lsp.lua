return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        -- https://github.com/typescript-language-server/typescript-language-server
        ts_ls = {
          enabled = true,
          keys = {
            {
              "<leader>co",
              LazyVim.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
            {
              "<leader>cM",
              LazyVim.lsp.action["source.addMissingImports.ts"],
              desc = "Add missing imports",
            },
            {
              "<leader>cu",
              LazyVim.lsp.action["source.removeUnused.ts"],
              desc = "Remove unused imports",
            },
            {
              "<leader>cD",
              LazyVim.lsp.action["source.fixAll.ts"],
              desc = "Fix all diagnostics",
            },
          },
          cmd = {
            "typescript-language-server",
            "--stdio",
          },
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
          init_options = {
            hostInfo = "neovim",
          },
        },
        vtsls = {
          enabled = false,
        },
      },
      setup = {
        vtsls = function()
          return true
        end,
      },
    },
  },
}
