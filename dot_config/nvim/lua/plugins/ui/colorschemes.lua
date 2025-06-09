return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },

  {
    "thesimonho/kanagawa-paper.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa-paper").setup({
        -- enable undercurls for underlined text
        undercurl = true,
        -- transparent background
        transparent = true,
        -- highlight background for the left gutter
        gutter = false,
        -- background for diagnostic virtual text
        diag_background = true,
        -- dim inactive windows. Disabled when transparent
        dim_inactive = false,
        -- set colors for terminal buffers
        terminal_colors = true,
        -- cache highlights and colors for faster startup.
        -- see Cache section for more details.
        cache = false,

        styles = {
          -- style for comments
          comment = { italic = true },
          -- style for functions
          functions = { italic = false },
          -- style for keywords
          keyword = { italic = false, bold = false },
          -- style for statements
          statement = { italic = false, bold = false },
          -- style for types
          type = { italic = false },
        },
        -- override default palette and theme colors
        colors = {
          palette = {},
          theme = {
            ink = {},
            canvas = {},
          },
        },
        -- adjust overall color balance for each theme [-1, 1]
        color_offset = {
          ink = { brightness = 1, saturation = 0 },
          canvas = { brightness = 0, saturation = 0 },
        },
        -- override highlight groups
        overrides = function(colors)
          -- https://github.com/thesimonho/kanagawa-paper.nvim/blob/master/palette_colors.md
          local theme = colors.theme
          -- local palette = colors.palette

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
            WinBar = { bg = "None" },
            WinBarNC = { bg = "None" },
            Pmenu = { bg = "None" },
            WinSeparator = { fg = theme.ui.float.fg_border, bg = "None" },
            LspInlayHint = { link = "Comment" },

            -- Plugin Specific Highlights
            BlinkCmpDoc = { link = "Pmenu" },
            BlinkCmpDocBorder = { link = "TelescopePromptBorder" },
            BlinkCmpMenuBorder = { link = "TelescopePromptBorder" },
            BlinkCmpSignatureHelpBorder = { link = "TelescopePromptBorder" },
            GitSignsAdd = { bg = "None" },
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            NoicePopupBorder = { link = "FloatBorder" },
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            TreesitterContext = { bg = "None" },
            TreesitterContextBottom = { sp = theme.ui.fg_dim, bg = "None" },
            TreesitterContextLineNumber = { bg = "None" },
            WhichKeyBorder = { fg = "None", bg = "None" },
          }
        end,

        -- uses lazy.nvim, if installed, to automatically enable needed plugins
        auto_plugins = true,
        -- enable highlights for all plugins (disabled if using lazy.nvim)
        all_plugins = package.loaded.lazy == nil,
        -- manually enable/disable individual plugins.
        -- check the `groups/plugins` directory for the exact names
        plugins = {
          -- examples:
          -- rainbow_delimiters = true
          -- which_key = false
        },

        -- enable integrations with other applications
        integrations = {
          wezterm = {
            -- automatically set wezterm theme to match the current neovim theme
            enabled = false,
            -- neovim will write the theme name to this file
            -- wezterm will read from this file to know which theme to use
            path = (os.getenv("TEMP") or "/tmp") .. "/nvim-theme",
          },
        },
      })
    end,
  },

  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require("everforest").setup({
        ---Controls the "hardness" of the background. Options are "soft", "medium" or "hard".
        ---Default is "medium".
        background = "medium",
        ---How much of the background should be transparent. 2 will have more UI
        ---components be transparent (e.g. status line background)
        transparent_background_level = 2,
        ---Whether italics should be used for keywords and more.
        italics = false,
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
        ---You can override specific highlights to use other groups or a hex colour.
        ---@param hl Highlights
        ---@param palette Palette https://github.com/neanias/everforest-nvim/blob/main/lua/everforest/colours.lua
        on_highlights = function(hl, palette)
          hl.NormalFloat = { bg = palette.none }
          hl.FloatBorder = { bg = palette.none }
          hl.Pmenu = { bg = palette.none }
        end,
        colours_override = function(palette) end,
      })
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
          WinSeparator = { bg = "None" },
          StatusLine = { bg = "None" },
          StatusLineNC = { bg = "None" },
          WinBar = { bg = "None" },
          WinBarNC = { bg = "None" },
          LineNr = { fg = C.comment },
          Pmenu = { bg = "None" },
          NonText = { fg = C.comment },
          FloatBorder = { link = "TelescopePromptBorder" },

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
}
