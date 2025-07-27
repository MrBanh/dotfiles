local wk = require 'which-key'
wk.add {
  '<leader>g',
  group = 'Git',
  icon = { icon = ' ' },
}
wk.add {
  { '<leader>gh', group = 'Hunk' },
}
wk.add {
  { '<leader>gb', group = 'Blame' },
}

return {
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    config = function(_, opts)
      require('git-conflict').setup(opts)
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map('n', '<leader>gs', gs.stage_buffer, 'Stage Buffer')
        map('n', '<leader>gd', gs.diffthis, 'Diff This')
        map('n', '<leader>gD', function()
          gs.diffthis '@'
        end, 'Diff this against last commit')
        map('n', '<leader>gp', gs.preview_hunk_inline, 'Preview hunk inline')
        map('n', '<leader>gx', gs.reset_buffer, 'Reset Buffer')
        map('n', '<leader>gX', gs.reset_base, 'Reset all changes')

        -- hunks
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gs.nav_hunk 'next'
          end
        end, 'Next Hunk')
        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gs.nav_hunk 'prev'
          end
        end, 'Prev Hunk')
        map('n', ']H', function()
          gs.nav_hunk 'last'
        end, 'Last Hunk')
        map('n', '[H', function()
          gs.nav_hunk 'first'
        end, 'First Hunk')
        map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', 'Stage/Unstage Hunk')
        map({ 'n', 'v' }, '<leader>ghx', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
        map('n', '<leader>ghp', gs.preview_hunk_inline, 'Preview Hunk Inline')

        -- blame
        map('n', '<leader>gbl', function()
          gs.blame_line { full = true }
        end, 'Blame Line')
        map('n', '<leader>gbb', function()
          gs.blame()
        end, 'Blame Buffer')

        -- toggles

        local current_line_blame = gs.toggle_current_line_blame()
        Snacks.toggle({
          name = 'Git Inline Blame',
          get = function()
            return current_line_blame
          end,
          set = function()
            current_line_blame = gs.toggle_current_line_blame()
          end,
        }):map '<leader>Tb'

        -- operator
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
      end,
    },
  },
}
