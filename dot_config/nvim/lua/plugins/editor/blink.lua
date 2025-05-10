return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      trigger = {
        show_in_snippet = false,
      },
      accept = {
        auto_brackets = {
          kind_resolution = {
            enabled = true,
            blocked_filetypes = { "typescriptreact", "javascriptreact", "astro" },
          },
        },
      },
      menu = {
        draw = {
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

    keymap = {
      preset = "super-tab",
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
