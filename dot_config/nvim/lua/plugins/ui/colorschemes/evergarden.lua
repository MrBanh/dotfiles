return {
  "everviolet/nvim",
  name = "evergarden",
  priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
  opts = {
    theme = {
      variant = "fall", -- 'winter'|'fall'|'spring'|'summer'
      accent = "green",
    },
    editor = {
      transparent_background = true,
      sign = { color = "none" },
      float = {
        color = "mantle",
        solid_border = false,
      },
      completion = {
        color = "surface0",
      },
    },
    style = {
      tabline = { "reverse" },
      search = { "italic", "reverse" },
      incsearch = { "italic", "reverse" },
      types = { "italic" },
      keyword = { "italic" },
      comment = { "italic" },
    },
    overrides = {
      NormalFloat = { bg = "none" },
      FloatBorder = { bg = "none" },
      Pmenu = { bg = "none" },
      PmenuBorder = { bg = "none" },
      CursorLine = { bg = "none" },

      RenderMarkdownH1Bg = { link = "RenderMarkdownHeadingBG" },
      RenderMarkdownH2Bg = { link = "RenderMarkdownHeadingBG" },
      RenderMarkdownH3Bg = { link = "RenderMarkdownHeadingBG" },
      RenderMarkdownH4Bg = { link = "RenderMarkdownHeadingBG" },
      RenderMarkdownH5Bg = { link = "RenderMarkdownHeadingBG" },
      RenderMarkdownH6Bg = { link = "RenderMarkdownHeadingBG" },
    },
    color_overrides = {},
  },
}
