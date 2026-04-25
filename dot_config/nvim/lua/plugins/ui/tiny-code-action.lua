return {
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      -- { "folke/snacks.nvim" },
    },
    event = "LspAttach",
    opts = {
      backend = "vim",
      picker = {
        -- "snacks",
        -- opts = {
        --   layout = {
        --     preset = "default",
        --     cycle = false,
        --   },
        -- },

        "buffer",
        opts = {
          hotkeys = true, -- Enable hotkeys for the buffer picker to quickly select an action

          -- sequential = a, b, c...
          -- text_based = "Fix all" => "f", "Fix others" => "o" (first non assigned letter of the action)
          -- text_diff_based = "Fix all" => "fa", "Fix others" => "fo" smarter than text_based
          hotkeys_mode = "sequential", -- "text_diff_based" | "text_based" | "sequential"
          auto_preview = true, -- Enable auto preview of the code action
          position = "cursor", -- "cursor" or "center"
          winborder = "rounded", -- Set the window border style ("single", "rounded", "solid", etc.)
          keymaps = {
            preview = "<C-l>", -- Key to show preview
            preview_close = "<C-h>", -- Keys to return from preview to main window (can be string or table)
            select = "<CR>",
            close = { "q", "<Esc>" },
          },
        },
      },
    },
    config = function(_, opts)
      require("tiny-code-action").setup(opts)

      -- The plugin's safe_buf_op pcalls preview rendering and emits a DEBUG
      -- vim.notify on failure ("Buffer operation failed: ..."). The preview
      -- still works (or just stays blank), but the notification is noisy.
      -- Drop the notify; keep the pcall.
      ---@diagnostic disable-next-line: duplicate-set-field
      require("tiny-code-action.utils").safe_buf_op = function(fn)
        return pcall(fn)
      end

      -- When the LSP fails to resolve an action the previewer surfaces a
      -- multi-line stack trace ("Unable to preview code action.\nError: ...").
      -- Replace it with a quiet placeholder.
      local prev = require("tiny-code-action.previewers.buffer")
      local orig_resolve = prev.preview_with_resolve
      ---@diagnostic disable-next-line: duplicate-set-field
      prev.preview_with_resolve = function(...)
        local content = orig_resolve(...)
        if type(content) == "table" and content[1] == "Unable to preview code action." then
          return { "No preview available for this action" }
        end
        return content
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            {
              "<leader>ca",
              function()
                require("tiny-code-action").code_action({})
              end,
              desc = "Code Action",
              mode = { "n", "x" },
              has = "codeAction",
            },
          },
        },
      },
    },
  },
}
