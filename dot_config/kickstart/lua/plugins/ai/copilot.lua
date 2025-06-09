return {
  {
    'zbirenbaum/copilot.lua',
    event = { 'InsertEnter' },
    cmd = { 'Copilot' },
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = true,
        keymap = {
          accept = false, -- handled by cmp
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-e>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    'saghen/blink.cmp',
    optional = true,
    dependencies = { 'fang2hou/blink-copilot' },
    opts = {
      sources = {
        default = { 'copilot' },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = 100,
            async = true,
          },
        },
      },
    },

    -- Copilot LSP for Next Edit Suggestions
    {
      'copilotlsp-nvim/copilot-lsp',
      lazy = false,
      init = function()
        local nes = require 'copilot-lsp.nes'

        vim.g.copilot_nes_debounce = 500
        vim.lsp.enable 'copilot_ls'

        -- Keymaps for Copilot Next Edit Suggestions
        vim.keymap.set('n', '<tab>', function()
          local _ = nes.walk_cursor_start_edit() or (nes.apply_pending_nes() and nes.walk_cursor_end_edit())
        end, {
          desc = 'Jump to start of suggestion edit or apply pending suggestion & jump to end of edit',
        })

        require('which-key').add {
          '<leader>as',
          group = 'Suggestions',
        }
        vim.keymap.set('n', '<leader>asn', function()
          nes.request_nes 'copilot_ls'
        end, { desc = 'Request Next Edit Suggestion' })

        vim.keymap.set('n', '<leader>asc', function()
          nes.clear_suggestion()
        end, { desc = 'Clear suggestion' })

        vim.keymap.set('n', '<C-e>', function()
          if not nes.clear() then
            return
          end
        end, { desc = 'Clear Copilot suggestion or fallback' })
      end,
    },
  },
}
