return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        keymap = {
          dismiss = "<C-c>",
        },
      },
    },
  },

  -- Copilot LSP for Next Edit Suggestions

  -- Only if you want inline completions with blink
  -- { import = "lazyvim.plugins.extras.ai.copilot" },
  -- {
  --   "giuxtaposition/blink-cmp-copilot",
  --   enabled = false,
  -- },
  -- {
  --   "saghen/blink.cmp",
  --   dependencies = { "fang2hou/blink-copilot" },
  --   opts = {
  --     keymap = {
  --       preset = "super-tab",
  --       ["<Tab>"] = {
  --         function(cmp)
  --           if vim.b[vim.api.nvim_get_current_buf()].nes_state then
  --             cmp.hide()
  --             return (
  --               require("copilot-lsp.nes").apply_pending_nes()
  --               and require("copilot-lsp.nes").walk_cursor_end_edit()
  --             )
  --           end
  --           if cmp.snippet_active() then
  --             return cmp.accept()
  --           else
  --             return cmp.select_and_accept()
  --           end
  --         end,
  --         "snippet_forward",
  --         "fallback",
  --       },
  --     },
  --     sources = {
  --       providers = {
  --         copilot = {
  --           module = "blink-copilot",
  --         },
  --       },
  --     },
  --   },
  -- },

  {
    "copilotlsp-nvim/copilot-lsp",
    init = function()
      local nes = require("copilot-lsp.nes")

      vim.g.copilot_nes_debounce = 500

      vim.api.nvim_create_autocmd({ "InsertEnter" }, {
        callback = function()
          if not nes.clear() then
            return
          end
        end,
      })

      vim.lsp.enable("copilot_ls")

      vim.keymap.set({ "n", "i" }, "<M-Tab>", function()
        local _ = nes.walk_cursor_start_edit()
          or (nes.apply_pending_nes() and nes.walk_cursor_end_edit())
          or nes.request_nes("copilot_ls")
      end, {
        desc = "Jump to start of suggestion edit or apply pending suggestion & jump to end of edit",
      })

      vim.keymap.set({ "n", "i" }, "<C-c>", function()
        if not nes.clear() then
          return
        end
      end, { desc = "Clear Copilot suggestion or fallback" })
    end,
  },
}
