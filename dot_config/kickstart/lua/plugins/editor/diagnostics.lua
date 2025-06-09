require('which-key').add {
  '<leader>x',
  group = 'Quickfix/diagnostics',
  icon = { icon = '󱖫 ', color = 'green' },
}

vim.keymap.set('n', '<leader>xl', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' })
vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xs', '<cmd>Trouble symbols toggle<cr>', { desc = 'Symbols (Trouble)' })
vim.keymap.set('n', '<leader>xS', '<cmd>Trouble lsp toggle<cr>', { desc = 'LSP references/definitions/... (Trouble)' })
vim.keymap.set('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location List (Trouble)' })
vim.keymap.set('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix List (Trouble)' })

return {
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble' },
    opts = {
      win = {
        wo = {
          wrap = true,
        },
      },
      modes = {
        diagnostics = {
          mode = 'diagnostics',
          preview = {
            type = 'split',
            relative = 'win',
            position = 'right',
            size = 0.5,
          },
        },
        lsp = {
          win = { position = 'right' },
        },
      },
    },
  },
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy', -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require('tiny-inline-diagnostic').setup {
        preset = 'powerline',
      }
      vim.diagnostic.config { virtual_text = false } -- Only if needed in your configuration, if you already have native LSP diagnostics
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = { diagnostics = { virtual_text = false } },
  },
}
