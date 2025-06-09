-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(
--
-- :h nvui
--

local options = {
  base46 = {
    theme = 'everforest',
    transparency = true,
    hl_override = {
      Comment = { italic = true },
      ['@comment'] = { italic = true },
      St_file_sep = { bg = 'none' },
      St_NormalModeSep = { bg = 'none' },
      St_VisualModeSep = { bg = 'none' },
      St_InsertModeSep = { bg = 'none' },
      St_TerminalModeSep = { bg = 'none' },
      St_NTerminalModeSep = { bg = 'none' },
      St_ReplaceModeSep = { bg = 'none' },
      St_ConfirmModeSep = { bg = 'none' },
      St_CommandModeSep = { bg = 'none' },
      St_SelectModeSep = { bg = 'none' },
      St_Pos_sep = { bg = 'none' },
      St_cwd_sep = { bg = 'none' },
    },
    hl_add = {},
    -- https://github.com/NvChad/base46/tree/v3.0/lua/base46/integrations
    integrations = {
      'blink',
      'dap',
      'diffview',
      'flash',
      'git',
      'git-conflict',
      'grug_far',
      'navic',
      'notify',
      'render-markdown',
      'semantic_tokens',
      -- 'tiny-inline-diagnostic',
      'todo',
      'trouble',
      'whichkey',
    },
    -- changed_themes = {},
    -- theme_toggle = { "onedark", "one_light" },
  },

  ui = {
    cmp = {
      lspkind_text = true,
      style = 'default', -- default/flat_light/flat_dark/atom/atom_colored
      abbr_maxwidth = 60,
      format_colors = {
        tailwind = true,
        lsp = true,
        icon = '󱓻',
      },
    },

    telescope = { style = 'borderless' }, -- borderless / bordered

    statusline = {
      enabled = true,
      theme = 'minimal', -- default/vscode/vscode_colored/minimal
      -- default/round/block/arrow separators work only for default statusline theme
      -- round and block will work for minimal theme only
      separator_style = 'round',
      order = { 'mode', 'file', 'git', '%=', 'lsp_msg', '%=', 'recording', 'diagnostics', 'lsp', 'cwd', 'cursor' },
      modules = {
        recording = function()
          if vim.fn.reg_recording() ~= '' then
            return 'Recording @' .. vim.fn.reg_recording()
          else
            return ''
          end
        end,
      },
    },

    -- lazyload it when there are 1+ buffers
    tabufline = {
      enabled = false,
      lazyload = true,
      order = { 'treeOffset', 'buffers', 'tabs', 'btns' },
      modules = nil,
      bufwidth = 21,
    },
  },

  nvdash = {
    load_on_startup = true,
    header = {
      '        ████                      ████        ',
      '      ██░░░░██                  ██░░░░██      ',
      '      ██░░░░██                  ██░░░░██      ',
      '    ██░░░░░░░░██████████████████░░░░░░░░██    ',
      '    ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██    ',
      '    ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██    ',
      '  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██  ',
      '  ██░░██░░░░████░░░░░░░░░░░░░░████░░░░██░░██  ',
      '  ██░░░░██░░████░░░░░░██░░░░░░████░░██░░░░██  ',
      '██░░░░██░░░░░░░░░░░░██████░░░░░░░░░░░░██░░░░██',
      '██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██',
      '██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██',
      '██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██',
      '██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██',
      '██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██',
      '',
    },

    buttons = {
      { txt = '  Find File', keys = 'ff', cmd = 'Telescope find_files' },
      { txt = '  Recent Files', keys = 'fo', cmd = 'Telescope oldfiles' },
      { txt = '󰈭  Find Word', keys = 'fw', cmd = 'Telescope live_grep' },
      { txt = '󰑓  Restore Session', keys = 's', cmd = ":lua require('persistence').load()" },

      { txt = '─', hl = 'NvDashFooter', no_gap = true, rep = true },
      {
        txt = function()
          local stats = require('lazy').stats()
          local ms = math.floor(stats.startuptime) .. ' ms'
          return '  Loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms
        end,
        hl = 'NvDashFooter',
        no_gap = true,
      },
      { txt = '─', hl = 'NvDashFooter', no_gap = true, rep = true },
    },
  },

  term = {
    base46_colors = true,
    winopts = { number = false, relativenumber = false },
    sizes = { sp = 0.3, vsp = 0.2, ['bo sp'] = 0.3, ['bo vsp'] = 0.2 },
    float = {
      relative = 'editor',
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
      border = 'single',
    },
  },

  lsp = { signature = true },

  cheatsheet = {
    enabled = false,
    theme = 'grid', -- simple/grid
    excluded_groups = { 'terminal (t)', 'autopairs', 'Nvim', 'Opens' }, -- can add group name or with mode
  },

  mason = { pkgs = {}, skip = {} },

  colorify = {
    enabled = true,
    mode = 'virtual', -- fg, bg, virtual
    virt_text = '󱓻 ',
    highlight = { hex = true, lspvars = true },
  },
}

return options
