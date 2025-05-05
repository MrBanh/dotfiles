local icons = LazyVim.config.icons

return {
  -- WINBAR/STATUSLINE
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.component_separators = ""
      opts.options.section_separators = { left = "", right = "" }
      opts.sections.lualine_a = { { "mode", separator = { left = "", right = "" } } }
      opts.sections.lualine_z = {
        {
          function()
            return " " .. os.date("%R")
          end,
          separator = { left = "", right = "" },
        },
      }
      opts.sections.lualine_c = {
        LazyVim.lualine.root_dir(),
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { LazyVim.lualine.pretty_path() },
        {
          "navic",
          color_correction = "static",
          navic_opts = {
            separator = " > ",
            icons_enabled = true,
            highlight = true,
            icons = LazyVim.config.icons.kinds,
            lazy_update_context = true,
            safe_output = true,
          },
        },
      }

      return opts
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "ayu",
    },
  },

  -- THEMES
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

      require("ayu").setup({
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
          VertSplit = { fg = C.bg, bg = "None" },
          WinSeparator = { fg = C.bg, bg = "None" },
          StatusLine = { bg = "None" },
          StatusLineNC = { bg = "None" },
          WinBar = { bg = "None" },
          WinBarNC = { bg = "None" },
          LineNr = { fg = "#6C7A8B" },

          -- treesitter-context
          TreesitterContext = {
            bg = "None",
          },

          -- Navic
          NavicIconsFile = { fg = C.entity },
          NavicIconsModule = { fg = C.entity },
          NavicIconsNamespace = { fg = C.entity },
          NavicIconsPackage = { fg = C.entity },
          NavicIconsClass = { fg = C.entity },
          NavicIconsMethod = { fg = C.func },
          NavicIconsFunction = { fg = C.func },
          NavicIconsConstructor = { fg = C.func },
          NavicIconsProperty = { fg = C.constant },
          NavicIconsField = { fg = C.constant },
          NavicIconsEnum = { fg = C.constant },
          NavicIconsInterface = { fg = C.constant },
          NavicIconsVariable = { fg = C.constant },
          NavicIconsConstant = { fg = C.constant },
          NavicIconsString = { fg = C.string },
          NavicIconsNumber = { fg = C.string },
          NavicIconsBoolean = { fg = C.string },
          NavicIconsArray = { fg = C.string },
          NavicIconsObject = { fg = C.string },
          NavicIconsKey = { fg = C.string },
          NavicIconsNull = { fg = C.string },
          NavicIconsEnumMember = { fg = C.string },
          NavicIconsStruct = { fg = C.string },
          NavicIconsEvent = { fg = C.string },
          NavicIconsOperator = { fg = C.operator },
          NavicIconsTypeParameter = { fg = C.lsp_parameter },
          NavicText = { fg = C.fg },
          NavicSeparator = { fg = C.fg },
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
