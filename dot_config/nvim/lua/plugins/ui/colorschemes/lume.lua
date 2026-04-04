return {
  "danfry1/lume",
  lazy = false,
  priority = 1000,
  config = function()
    require("lume").setup({
      transparent = true,
      italics = true,
      palette_overrides = { -- override base palette colors before they cascade to all groups
        -- foregrounds = { text = "#c8c8d8" }, -- softer foreground
        -- accents = { lavender = "#a890d0" }, -- tweak any accent
      },
      custom_highlights = function(colors, variant)
        -- colors contains: backgrounds, foregrounds, accents, ansi, special
        -- variant is "dark" (or "light" when a light theme is added)
        -- https://github.com/danfry1/lume/blob/main/lua/lume/palette.lua
        return {
          -- Normal = { bg = "#1E1F2E" },
          -- MiniDiffSignAdd = { fg = colors.accents.sage },
          NormalFloat = { bg = "none" },
          LazyBorder = { bg = "none" },
          FloatBorder = { bg = "none" },
          Pmenu = { bg = "none" },
          PmenuExtra = { link = "Pmenu" },
          PmenuSel = { bg = colors.backgrounds.surface0, fg = "none" },
          PmenuSelExtra = { link = "PmenuSel" },

          NoiceCmdline = { bg = "none" },
          NoiceCmdlinePopup = { bg = "none" },
          NoiceCmdlinePopupBorder = { fg = colors.accents.lavender, bg = "none" },
          NoiceCmdlinePopupTitleSearch = { bg = "none" },
          NoiceCmdlinePopupBorderSearch = { bg = "none" },

          CursorLine = { bg = colors.backgrounds.surface0 },
          SnacksPickerListCursorLine = { link = "CursorLine" },
          NonText = { link = "Comment" },

          RenderMarkdownH1Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownH2Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownH3Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownH4Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownH5Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownH6Bg = { link = "RenderMarkdownHeadingBG" },
        }
      end,
    })
  end,
}
