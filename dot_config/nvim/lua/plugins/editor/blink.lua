return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      accept = {
        auto_brackets = {
          kind_resolution = {
            enabled = true,
            blocked_filetypes = { "typescriptreact", "javascriptreact", "astro" },
          },
          semantic_token_resolution = {
            enabled = true,
            blocked_filetypes = { "typescriptreact", "javascriptreact", "astro" },
          },
        },
      },
      menu = {
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "source_name", gap = 1 },
            { "kind_icon", "kind", gap = 1 },
          },
          components = {
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                return kind_icon
              end,
              -- (optional) use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
            kind = {
              -- (optional) use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
          },
        },
      },
    },
    cmdline = {
      enabled = true,
      completion = {
        ghost_text = { enabled = true },
        list = {
          selection = {
            -- When `true`, will automatically select the first item in the completion list
            preselect = false,
          },
        },
      },
    },

    keymap = {
      ["<CR>"] = { "accept", "fallback" },
    },

    fuzzy = {
      implementation = "prefer_rust_with_warning",
      use_frecency = true,
      sorts = {
        "exact",
        "score",
        "sort_text",
      },
    },
  },
}
