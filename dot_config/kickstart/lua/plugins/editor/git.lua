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
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
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
        map('n', '<leader>Tb', gs.toggle_current_line_blame, 'Toggle git show blame line')
        map('n', '<leader>TD', gs.preview_hunk_inline, 'Toggle git show deleted')

        -- operator
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
      end,
    },
  },
}
