return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "ayu",
    },
  },

  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        blink_cmp = true,
        snacks = true,
      },
    },
  },

  {
    "Shatur/neovim-ayu",
    lazy = true,
    name = "ayu",
    config = function()
      local C = require("ayu.colors")
      C.generate(true)

      --[[
        https://github.com/Shatur/neovim-ayu/blob/master/lua/ayu/colors.lua

        accent = '#FFCC66'
        bg = '#1F2430'
        fg = '#CCCAC2'
        ui = '#707A8C'
        tag = '#5CCFE6'
        func = '#FFD173'
        entity = '#73D0FF'
        string = '#D5FF80'
        regexp = '#95E6CB'
        markup = '#F28779'
        keyword = '#FFAD66'
        special = '#FFDFB3'
        comment = '#6C7A8B'
        constant = '#DFBFFF'
        operator = '#F29E74'
        error = '#FF6666'
        lsp_parameter = '#D3B8F9'
        line = '#171B24'
        panel_bg = '#1C212B'
        panel_shadow = '#161922'
        panel_border = '#101521'
        gutter_normal = '#4A505A'
        gutter_active = '#757B84'
        selection_bg = '#274364'
        selection_inactive = '#23344B'
        selection_border = '#232A4C'
        guide_active = '#444A55'
        guide_normal = '#323843'
        vcs_added = '#87D96C'
        vcs_modified = '#80BFFF'
        vcs_removed = '#F27983'
        vcs_added_bg = '#313D37'
        vcs_removed_bg = '#3E373A'
        fg_idle = '#707A8C'
        warning = '#FFA759'
      --]]

      require("ayu").setup({
        mirage = true, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
        terminal = true, -- Set to `false` to let terminal manage its own colors.
        overrides = {
          -- https://github.com/Shatur/neovim-ayu/blob/master/lua/ayu/init.lua
          Normal = { bg = "None" },
          NormalFloat = { bg = "none" },
          ColorColumn = { bg = "None" },
          SignColumn = { bg = "None" },
          Folded = { bg = "None" },
          FoldColumn = { bg = "None" },
          CursorLine = { bg = "None" },
          CursorColumn = { bg = "None" },
          WinSeparator = { fg = C.accent, bg = "None" },
          StatusLine = { bg = "None" },
          StatusLineNC = { bg = "None" },
          WinBar = { bg = "None" },
          WinBarNC = { bg = "None" },
          LineNr = { fg = C.comment },
          Pmenu = { bg = "None" },
          NonText = { fg = C.comment },

          -- blink: https://cmp.saghen.dev/configuration/appearance.html#highlight-groups
          BlinkCmpDoc = { link = "Pmenu" },
          BlinkCmpDocBorder = { link = "TelescopePromptBorder" },
          BlinkCmpMenuBorder = { link = "TelescopePromptBorder" },
          BlinkCmpSignatureHelpBorder = { link = "TelescopePromptBorder" },

          -- Snacks
          SnacksPickerDir = {
            fg = C.comment,
          },
          SnacksPickerDimmed = {
            fg = C.comment,
          },

          -- treesitter-context
          TreesitterContext = {
            bg = "None",
          },
        },
      })
    end,
  },
  {
    "AlexvZyl/nordic.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent = {
        bg = true,
        float = true,
      },
    },
  },
}
