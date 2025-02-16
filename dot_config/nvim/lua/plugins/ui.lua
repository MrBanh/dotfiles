return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },

  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
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
    lazy = false,
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
    lazy = false,
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
        LineNr = { fg = "#6C7A8B" },
      },
    },
  },
}
