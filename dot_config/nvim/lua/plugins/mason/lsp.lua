return {
  {
    -- sticking with this because vtsls does not handle file renames well (does not update imports)
    "pmizio/typescript-tools.nvim",
    event = { "BufReadPost *.ts", "BufReadPost *.js", "BufReadPost *.tsx", "BufReadPost *.jsx" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "neovim/nvim-lspconfig",
        opts = {
          servers = {
            ts_ls = {
              enabled = false,
            },
            vtsls = {
              enabled = false,
            },
          },
        },
      },
    },
    opts = {
      settings = {
        tsserver_path = nil,
        tsserver_plugins = {},
        -- spawn additional tsserver instance to calculate diagnostics on it
        separate_diagnostic_server = true,
        -- "change"|"insert_leave" determine when the client asks the server about diagnostic
        publish_diagnostic_on = "insert_leave",
        -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
        -- "remove_unused_imports"|"organize_imports") -- or string "all"
        -- to include all supported code actions
        -- specify commands exposed as code_actions
        expose_as_code_action = { "fix_all", "add_missing_imports", "organize_imports", "remove_unused" },
        -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
        -- memory limit in megabytes or "auto"(basically no limit)
        tsserver_max_memory = "auto",
        tsserver_format_options = {},
        tsserver_file_preferences = {},
        tsserver_locale = "en",
        complete_function_calls = false,
        include_completions_with_insert_text = true,
        code_lens = "off", -- 'off' | 'all' | 'implementations_only' | 'references_only'
        disable_member_code_lens = true,
        jsx_close_tag = {
          enable = false,
          filetypes = { "javascriptreact", "typescriptreact" },
        },
      },
    },
    keys = {
      {
        "<leader>co",
        ":TSToolsOrganizeImports<CR>",
        desc = "Organize Imports",
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      },
      {
        "<leader>ci",
        ":TSToolsAddMissingImports<CR>",
        desc = "Add missing imports",
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      },
      {
        "<leader>cu",
        ":TSToolsRemoveUnused<CR>",
        desc = "Remove unused statements",
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      },
      {
        "<leader>cD",
        ":TSToolsFixAll<CR>",
        desc = "Fix all diagnostics",
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      },
      {
        "gR",
        ":TSToolsFileReferences<CR>",
        desc = "File References",
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      },
    },
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     inlay_hints = { enabled = false },
  --     servers = {
  --       vtsls = {
  --         keys = {
  --           {
  --             "<leader>cM",
  --             false,
  --           },
  --           {
  --             "<leader>ci",
  --             LazyVim.lsp.action["source.addMissingImports.ts"],
  --             desc = "Add missing imports",
  --           },
  --         },
  --       },
  --       -- https://github.com/typescript-language-server/typescript-language-server
  --       ts_ls = {
  --         keys = {
  --           {
  --             "<leader>co",
  --             LazyVim.lsp.action["source.organizeImports"],
  --             desc = "Organize Imports",
  --           },
  --           {
  --             "<leader>ci",
  --             LazyVim.lsp.action["source.addMissingImports.ts"],
  --             desc = "Add missing imports",
  --           },
  --           {
  --             "<leader>cu",
  --             LazyVim.lsp.action["source.removeUnused.ts"],
  --             desc = "Remove unused imports",
  --           },
  --           {
  --             "<leader>cD",
  --             LazyVim.lsp.action["source.fixAll.ts"],
  --             desc = "Fix all diagnostics",
  --           },
  --         },
  --         cmd = {
  --           "typescript-language-server",
  --           "--stdio",
  --         },
  --         filetypes = {
  --           "javascript",
  --           "javascriptreact",
  --           "javascript.jsx",
  --           "typescript",
  --           "typescriptreact",
  --           "typescript.tsx",
  --         },
  --         root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  --         init_options = {
  --           hostInfo = "neovim",
  --         },
  --       },
  --     },
  --   },
  -- },
}
