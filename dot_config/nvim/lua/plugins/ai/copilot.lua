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
  {
    "giuxtaposition/blink-cmp-copilot",
    enabled = false,
  },
  {
    "saghen/blink.cmp",
    dependencies = { "fang2hou/blink-copilot" },
    opts = {
      sources = {
        providers = {
          copilot = {
            module = "blink-copilot",
          },
        },
      },
    },
  },

  -- Copilot LSP for Next Edit Suggestions
  -- {
  --   "copilotlsp-nvim/copilot-lsp",
  --   init = function()
  --     local nes = require("copilot-lsp.nes")
  --
  --     vim.g.copilot_nes_debounce = 500
  --
  --     vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  --       callback = function()
  --         if not nes.clear() then
  --           return
  --         end
  --       end,
  --     })
  --
  --     vim.lsp.enable("copilot_ls")
  --
  --     vim.keymap.set({ "n", "i" }, "<M-Tab>", function()
  --       local _ = nes.walk_cursor_start_edit()
  --         or (nes.apply_pending_nes() and nes.walk_cursor_end_edit())
  --         or nes.request_nes("copilot_ls")
  --     end, {
  --       desc = "Jump to start of suggestion edit or apply pending suggestion & jump to end of edit",
  --     })
  --
  --     vim.keymap.set({ "n", "i" }, "<C-c>", function()
  --       if not nes.clear() then
  --         return
  --       end
  --     end, { desc = "Clear Copilot suggestion or fallback" })
  --   end,
  -- },
}
