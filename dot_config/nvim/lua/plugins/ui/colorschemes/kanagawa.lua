return {
  "rebelot/kanagawa.nvim",
  lazy = true,
  priority = 1000,
  config = function()
    -- Default options:
    require("kanagawa").setup({
      compile = false, -- enable compiling the colorscheme
      undercurl = true, -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = true, -- do not set background color
      dimInactive = false, -- dim inactive window `:h hl-NormalNC`
      terminalColors = true, -- define vim.g.terminal_color_{0,17}
      colors = { -- add/modify theme and palette colors
        palette = {},
        theme = {
          wave = {},
          lotus = {},
          dragon = {},
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
      overrides = function(colors) -- add/modify highlights
        local theme = colors.theme

        return {
          FloatTitle = { fg = theme.ui.float.fg, bg = "none" },
          FloatBorder = { link = "TelescopePromptBorder" },
          Normal = { bg = "None" },
          NormalFloat = { bg = "none" },
          ColorColumn = { bg = "None" },
          SignColumn = { bg = "None" },
          Folded = { bg = "None" },
          FoldColumn = { bg = "None" },
          CursorLine = { bg = "None" },
          CursorColumn = { bg = "None" },
          StatusLine = { bg = "None" },
          StatusLineNC = { bg = "None" },
          LineNr = { bg = "None" },
          WinBar = { bg = "None", bold = true, cterm = { bold = true } },
          WinBarNC = { bg = "None" },
          Pmenu = { bg = "None" },
          WinSeparator = { fg = theme.ui.float.fg_border, bg = "None" },
          LspInlayHint = { link = "Comment" },

          -- Plugin Specific Highlights
          BlinkCmpDoc = { link = "Pmenu" },
          BlinkCmpDocBorder = { link = "TelescopePromptBorder" },
          BlinkCmpMenuBorder = { link = "TelescopePromptBorder" },
          BlinkCmpSignatureHelpBorder = { link = "TelescopePromptBorder" },
          NoicePopupBorder = { link = "FloatBorder" },
          NoiceCmdlinePopupBorder = { link = "FloatBorder" },
          RenderMarkdownCode = { bg = theme.ui.bg_m3 },
          TreesitterContext = { bg = "None" },
          TreesitterContextBottom = { sp = theme.ui.fg_dim, bg = "None" },
          TreesitterContextLineNumber = { bg = "None" },
          WhichKeyBorder = { fg = "None", bg = "None" },
        }
      end,
      theme = "dragon", -- Load "wave" theme
      background = { -- map the value of 'background' option to a theme
        dark = "dragon", -- try "dragon" !
        light = "lotus",
      },
    })
  end,
}
