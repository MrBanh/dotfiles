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
      keymap = {
        preset = 'super-tab',
        ['<Tab>'] = {
          function(cmp)
            if vim.b[vim.api.nvim_get_current_buf()].nes_state then
              cmp.hide()
              return (require('copilot-lsp.nes').apply_pending_nes() and require('copilot-lsp.nes').walk_cursor_end_edit())
            end
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          'snippet_forward',
          'fallback',
        },
      },
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

        vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
          callback = function()
            if not nes.clear() then
              return
            end
          end,
        })

        vim.lsp.enable 'copilot_ls'

        -- Keymaps for Copilot Next Edit Suggestions
        vim.keymap.set('n', 'g<Tab>', function()
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
