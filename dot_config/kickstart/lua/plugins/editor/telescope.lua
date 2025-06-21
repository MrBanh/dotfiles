require('which-key').add { '<leader>f', group = 'Find' }
require('which-key').add { '<leader>s', group = 'Search' }

local build_cmd ---@type string?
for _, cmd in ipairs { 'make', 'cmake', 'gmake' } do
  if vim.fn.executable(cmd) == 1 then
    build_cmd = cmd
    break
  end
end

local focus_preview = function(prompt_bufnr)
  local action_state = require 'telescope.actions.state'
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_win = picker.prompt_win
  local previewer = picker.previewer
  local winid = previewer.state.winid
  local bufnr = previewer.state.bufnr
  vim.keymap.set('n', '<Tab>', function()
    vim.cmd(string.format('noautocmd lua vim.api.nvim_set_current_win(%s)', prompt_win))
  end, { buffer = bufnr })
  vim.cmd(string.format('noautocmd lua vim.api.nvim_set_current_win(%s)', winid))
  -- api.nvim_set_current_win(winid)
end

return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      'nvim-telescope/telescope-fzf-native.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
      local actions = require 'telescope.actions'
      local builtin = require 'telescope.builtin'
      local fb_actions = require 'telescope._extensions.file_browser.actions'

      require('telescope').setup {
        -- https://github.com/nvim-telescope/telescope.nvim/blob/b4da76be54691e854d3e0e02c36b0245f945c2c7/lua/telescope/mappings.lua#L133
        defaults = {
          mappings = {
            i = {
              ['<C-s>'] = actions.select_horizontal,
              ['<C-x>'] = function(...)
                actions.delete_buffer(...)
              end,
              ['<Tab>'] = focus_preview,
            },
            n = {
              ['<C-n>'] = actions.move_selection_next,
              ['<C-p>'] = actions.move_selection_previous,
              ['<C-s>'] = actions.select_horizontal,
              ['<C-x>'] = function(...)
                actions.delete_buffer(...)
              end,
              ['q'] = actions.close,
              ['<Tab>'] = focus_preview,
            },
          },
        },
        pickers = {
          find_files = {
            theme = 'ivy',
          },
          live_grep = {
            theme = 'ivy',
          },
          grep_string = {
            theme = 'ivy',
          },
        },
        -- https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
          },
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          file_browser = {
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            initial_mode = 'normal',
            grouped = true,
            sorting_strategy = 'ascending',
            mappings = {
              ['i'] = {
                ['<C-h>'] = fb_actions.goto_parent_dir,
                ['<C-e>'] = fb_actions.goto_cwd,
                ['<C-c>'] = fb_actions.change_cwd,
                ['<C-f>'] = fb_actions.toggle_browser,
                ['<C-.>'] = fb_actions.toggle_hidden,
                ['<C-a>'] = fb_actions.toggle_all,
                ['<bs>'] = fb_actions.backspace,

                ['<A-c>'] = false,
                ['<S-CR>'] = false,
                ['<A-r>'] = false,
                ['<A-m>'] = false,
                ['<A-y>'] = false,
                ['<A-d>'] = false,
                ['<C-o>'] = false,
                ['<C-g>'] = false,
                -- ['<C-e>'] = false,
                ['<C-w>'] = false,
                ['<C-t>'] = false,
                -- ['<C-f>'] = false,
                -- ['<C-h>'] = false,
                ['<C-s>'] = false,
                -- ['<bs>'] = false,
              },
              ['n'] = {
                ['a'] = fb_actions.create,
                ['r'] = fb_actions.rename,
                ['m'] = fb_actions.move,
                ['y'] = fb_actions.copy,
                ['d'] = fb_actions.remove,
                ['o'] = fb_actions.open,

                ['~'] = fb_actions.goto_home_dir,
                ['h'] = fb_actions.goto_parent_dir,
                ['e'] = fb_actions.goto_cwd,
                ['c'] = fb_actions.change_cwd,
                ['f'] = fb_actions.toggle_browser,
                ['.'] = fb_actions.toggle_hidden,
                ['<C-a>'] = fb_actions.toggle_all,
                ['<bs>'] = fb_actions.backspace,

                ['g'] = false,
                ['w'] = false,
                ['t'] = false,
                ['s'] = false,
              },
            },
          },
        },
      }

      -- extensions
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'file_browser')

      local set = vim.keymap.set

      set('n', '<space>e', ':Telescope file_browser path=%:p:h select_buffer=true<CR>')

      set('n', '<leader>/', '<cmd>Telescope live_grep<CR>', { desc = 'live grep', remap = true })
      set('n', '<leader>:', '<cmd>Telescope command_history<CR>', { desc = 'Command history' })
      set('n', '<leader><space>', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })

      -- Find in current workspace
      vim.keymap.set('n', '<leader>f/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = 'Find in Open Files' })

      set('n', '<leader>fa', '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>', { desc = 'Find all files' })
      set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'Buffers' })
      set('n', '<leader>fd', '<cmd>Telescope diagnostics bufnr=0<CR>', { desc = 'Document diagnostics' })
      set('n', '<leader>fD', '<cmd>Telescope diagnostics<CR>', { desc = 'Workspace diagnostics' })
      set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Files' })
      set('n', '<leader>fj', '<cmd>Telescope jumplist<CR>', { desc = 'Jumplist' })
      set('n', '<leader>fl', '<cmd>Telescope loclist<CR>', { desc = 'Location list' })
      set('n', '<leader>fm', '<cmd>Telescope marks<CR>', { desc = 'Marks' })
      set('n', '<leader>fo', '<cmd>Telescope oldfiles<CR>', { desc = 'Old files' })
      set('n', '<leader>fR', '<cmd>Telescope resume<CR>', { desc = 'Resume' })
      set('n', '<leader>fq', '<cmd>Telescope quickfix<CR>', { desc = 'Quickfix' })
      set('n', '<leader>fs', function()
        builtin.lsp_document_symbols()
      end, {
        desc = 'Goto Symbol',
      })
      set('n', '<leader>fS', function()
        builtin.lsp_dynamic_workspace_symbols()
      end, {
        desc = 'Goto Symbol (Workspace)',
      })
      set('n', '<leader>fw', '<cmd>Telescope live_grep<CR>', { desc = 'live grep' })
      set('v', '<leader>fw', '<cmd>Telescope grep_string<CR>', { desc = 'live grep word' })
      set('n', '<leader>fW', '<cmd>Telescope grep_string<CR>', { desc = 'live grep word' })
      set('n', '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { desc = 'Find in current buffer' })

      -- Git
      set('n', '<leader>fg', '<cmd>Telescope git_files<CR>', { desc = 'Find git files' })
      set('n', '<leader>gc', '<cmd>Telescope git_commits<CR>', { desc = 'Git Commits' })
      set('n', '<leader>gs', '<cmd>Telescope git_status<CR>', { desc = 'Git Status' })

      -- Search (external)
      require('which-key').add { '<leader>s', group = 'Search' }
      set('n', '<leader>sa', '<cmd>Telescope autocommands<CR>', { desc = 'Autocommands' })
      set('n', '<leader>sc', '<cmd>Telescope command_history<CR>', { desc = 'Command history' })
      set('n', '<leader>sC', '<cmd>Telescope commands<CR>', { desc = 'Commands' })
      set('n', '<leader>sh', '<cmd>Telescope help_tags<CR>', { desc = 'Help pages' })
      set('n', '<leader>sH', '<cmd>Telescope highlights<CR>', { desc = 'Highlight groups' })
      set('n', '<leader>sk', '<cmd>Telescope keymaps<CR>', { desc = 'Keymaps' })
      set('n', '<leader>sm', '<cmd>Telescope man_pages<CR>', { desc = 'Man pages' })
      set('n', '<leader>so', '<cmd>Telescope vim_options<CR>', { desc = 'Options' })
      set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'Neovim config' })
      set('n', '<leader>sr', '<cmd>Telescope registers<CR>', { desc = 'Registers' })
      set('n', '<leader>st', '<cmd>Telescope themes<CR>', { desc = 'Themes' })

      -- LSP
      set('n', 'gd', function()
        builtin.lsp_definitions { reuse_win = true }
      end, { desc = 'Goto Definition' })
      set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { desc = 'References', nowait = true })
      set('n', 'gI', function()
        builtin.lsp_implementations { reuse_win = true }
      end, { desc = 'Goto Implementation' })
      set('n', 'gy', function()
        builtin.lsp_type_definitions { reuse_win = true }
      end, { desc = 'Goto T[y]pe Definition' })
    end,
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = (build_cmd ~= 'cmake') and 'make'
      or 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
  },
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  },
}
