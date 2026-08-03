return {
  "Aejkatappaja/cendre",
  lazy = false,
  priority = 1000,
  config = function()
    require("cendre").setup({
      background = "hard", -- "hard" | "medium" | "soft"
      transparent = true,
      italic_virtual_text = false,
      on_highlights = function(hl, c)
        hl.Pmenu = { bg = "None", fg = c.bg3 }
        hl.PmenuExtra = { bg = "None", fg = c.fg }
        hl.PmenuExtraSel = { bg = c.bg3, fg = c.fg }

        hl.BlinkCmpDoc = { link = "Pmenu" }
        hl.BlinkCmpDocBorder = { link = "PmenuBorder" }

        hl.BlinkCmpMenu = { link = "Pmenu" }
        hl.BlinkCmpMenuBorder = { link = "PmenuBorder" }

        hl.BlinkCmpSignatureHelp = { link = "Pmenu" }
        hl.BlinkCmpSignatureHelpBorder = { link = "PmenuBorder" }
      end,
    })
  end,
}
