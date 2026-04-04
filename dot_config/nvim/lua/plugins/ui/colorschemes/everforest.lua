return {
  "neanias/everforest-nvim",
  version = false,
  lazy = true,
  priority = 1000, -- make sure to load this before all the other start plugins
  -- Optional; default configuration will be used if setup isn't called.
  config = function()
    require("everforest").setup({
      ---Controls the "hardness" of the background. Options are "soft", "medium" or "hard".
      ---Default is "medium".
      background = "hard",
      ---How much of the background should be transparent. 2 will have more UI
      ---components be transparent (e.g. status line background)
      transparent_background_level = 2,
      ---Whether italics should be used for keywords and more.
      italics = true,
      ---Disable italic fonts for comments. Comments are in italics by default, set
      ---this to `true` to make them _not_ italic!
      disable_italic_comments = false,
      ---By default, the colour of the sign column background is the same as the as normal text
      ---background, but you can use a grey background by setting this to `"grey"`.
      sign_column_background = "none",
      ---The contrast of line numbers, indent lines, etc. Options are `"high"` or
      ---`"low"` (default).
      ui_contrast = "low",
      ---Dim inactive windows. Only works in Neovim. Can look a bit weird with Telescope.
      ---
      ---When this option is used in conjunction with show_eob set to `false`, the
      ---end of the buffer will only be hidden inside the active window. Inside
      ---inactive windows, the end of buffer filler characters will be visible in
      ---dimmed symbols. This is due to the way Vim and Neovim handle `EndOfBuffer`.
      dim_inactive_windows = false,
      ---Some plugins support highlighting error/warning/info/hint texts, by
      ---default these texts are only underlined, but you can use this option to
      ---also highlight the background of them.
      diagnostic_text_highlight = false,
      ---Which colour the diagnostic text should be. Options are `"grey"` or `"coloured"` (default)
      diagnostic_virtual_text = "coloured",
      ---Some plugins support highlighting error/warning/info/hint lines, but this
      ---feature is disabled by default in this colour scheme.
      diagnostic_line_highlight = false,
      ---By default, this color scheme won't colour the foreground of |spell|, instead
      ---colored under curls will be used. If you also want to colour the foreground,
      ---set this option to `true`.
      spell_foreground = false,
      ---Whether to show the EndOfBuffer highlight.
      show_eob = true,
      ---Style used to make floating windows stand out from other windows. `"bright"`
      ---makes the background of these windows lighter than |hl-Normal|, whereas
      ---`"dim"` makes it darker.
      ---
      ---Floating windows include for instance diagnostic pop-ups, scrollable
      ---documentation windows from completion engines, overlay windows from
      ---installers, etc.
      ---
      ---NB: This is only significant for dark backgrounds as the light palettes
      ---have the same colour for both values in the switch.
      float_style = "bright",
      ---Inlay hints are special markers that are displayed inline with the code to
      ---provide you with additional information. You can use this option to customize
      ---the background color of inlay hints.
      inlay_hints_background = "none", -- or "dimmed"
      -- https://github.com/neanias/everforest-nvim/blob/main/lua/everforest/colours.lua
      on_highlights = function(hl, palette)
        local highlights = {
          NormalFloat = { bg = palette.none },
          FloatBorder = { bg = palette.none },
          Pmenu = { bg = palette.none },
          PmenuSel = { bg = palette.bg_green, fg = palette.none },

          NonText = { link = "Comment" },
          TSParameter = { fg = palette.purple },
          LspSignatureActiveParameter = { bg = palette.bg1 },

          TreesitterContextLineNumber = { fg = palette.yellow },
          TreesitterContext = { bg = palette.none },

          GitConflictCurrent = { bg = palette.bg_blue },
          GitConflictCurrentLabel = { link = "GitConflictCurrent" },
          DiffChange = { bg = palette.none },

          RenderMarkdownH1Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownH2Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownH3Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownH4Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownH5Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownH6Bg = { link = "RenderMarkdownHeadingBG" },
          RenderMarkdownHeadingBG = { bg = "#2D2737" },
        }

        for group, opts in pairs(highlights) do
          hl[group] = opts
        end
      end,
      colours_override = function(palette) end,
    })
  end,
}
