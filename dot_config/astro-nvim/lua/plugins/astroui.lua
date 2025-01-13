-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "frappe",
      transparent_background = true,
    },
  },
  {
    "/Shatur/neovim-ayu",
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
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      -- change colorscheme
      colorscheme = "ayu",

      -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
      -- highlights = {
      --   init = { -- this table overrides highlights in all themes
      --     -- Normal = { bg = "#000000" },
      --     -- Example list: https://github.com/Shatur/neovim-ayu/blob/master/lua/ayu/init.lua#L28
      --     WinBar = {
      --       fg = "None",
      --     },
      --   },
      --   astrodark = { -- a table of overrides/changes when applying the astrotheme theme
      --     -- Normal = { bg = "#000000" },
      --   },
      -- },
      -- -- Icons can be configured throughout the interface
      -- icons = {
      --   -- configure the loading of the lsp in the status line
      --   LSPLoading1 = "⠋",
      --   LSPLoading2 = "⠙",
      --   LSPLoading3 = "⠹",
      --   LSPLoading4 = "⠸",
      --   LSPLoading5 = "⠼",
      --   LSPLoading6 = "⠴",
      --   LSPLoading7 = "⠦",
      --   LSPLoading8 = "⠧",
      --   LSPLoading9 = "⠇",
      --   LSPLoading10 = "⠏",
      -- },
      -- -- heirline status line config: https://docs.astronvim.com/recipes/status/
      -- status = {
      --   separators = {
      --     breadcrumbs = " > ",
      --     path = " > ",
      --   },
      -- },
      -- icon_highlights = {
      --   -- enable or disable breadcrumb icon highlighting
      --   breadcrumbs = true,
      --   -- Enable or disable the highlighting of filetype icons both in the statusline and tabline
      --   file_icon = {
      --     tabline = function(self) return self.is_active or self.is_visible end,
      --     statusline = true,
      --   },
      -- },
    },
  },

  -- Causes double lsp client in statusline if left in `community.lua`
  { import = "astrocommunity.recipes.heirline-nvchad-statusline" },
}
