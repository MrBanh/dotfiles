return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        component_separators = "",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "", right = "" } } },
        lualine_z = {
          {
            function()
              return " " .. os.date("%R")
            end,
            separator = { left = "", right = "" },
          },
        },
      },
    },
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

  {
    "bluz71/vim-nightfly-colors",
    name = "nightfly",
    lazy = true,
    priority = 1000,
    config = function()
      vim.g.nightflyWinSeparator = 2
      vim.g.nightflyNormalFloat = true
      vim.g.nightflyTransparent = true
    end,
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
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      variant = "dark",
      transparent = true,
    },
  },

  {
    "Shatur/neovim-ayu",
    lazy = true,
    name = "ayu",
    opts = {
      mirage = true, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
      terminal = true, -- Set to `false` to let terminal manage its own colors.
      overrides = {
        -- https://github.com/Shatur/neovim-ayu/blob/master/lua/ayu/colors.lua
        Normal = { bg = "None" },
        NormalFloat = { bg = "none" },
        ColorColumn = { bg = "None" },
        SignColumn = { bg = "None" },
        Folded = { bg = "None" },
        FoldColumn = { bg = "None" },
        CursorLine = { bg = "None" },
        CursorColumn = { bg = "None" },
        VertSplit = { bg = "None" },
        WinSeparator = { bg = "None" },
        StatusLine = { bg = "None" },
        StatusLineNC = { bg = "None" },
        WinBar = { bg = "None" },
        WinBarNC = { bg = "None" },
        LineNr = { fg = "#6C7A8B" },
      },
    },
  },
}
