local disabled_filetypes = {
  "help",
  "toggleterm",
  "snacks_dashboard",
  "checkhealth",
  "Diffview*",
  "netrw",
  "noice",
  "qf",
  "undotree",
  "Trouble",
  "dap-repl",
  "leetcode.nvim",
  "sidekick_terminal",
  "opencode",
  "opencode_output",
}

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local icons = LazyVim.config.icons

      -- https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
      local custom_theme = require("lualine.themes.nightfox")
      -- local custom_theme = require("lualine.themes.auto")
      local lualine_modes = { "normal", "inactive" }
      for _, field in ipairs(lualine_modes) do
        if custom_theme[field] and custom_theme[field].c then
          custom_theme[field].c.bg = "NONE"
        end
      end

      opts.options.theme = custom_theme

      opts.options.disabled_filetypes.winbar = disabled_filetypes

      -- separators
      local l_separator = ""
      local r_separator = ""

      opts.options.component_separators = ""
      opts.options.section_separators = { left = r_separator, right = l_separator }

      -- sections: https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#available-components
      opts.sections.lualine_a = { { "mode", separator = { right = r_separator } } }
      opts.sections.lualine_c = {
        LazyVim.lualine.root_dir({
          ---@diagnostic disable-next-line: assign-type-mismatch
          cwd = true,
        }),
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { LazyVim.lualine.pretty_path({
          relative = "root",
          length = 5,
        }) },
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
      }
      opts.sections.lualine_y = {
        { "progress", separator = " ", padding = { left = 1, right = 0 } },
        {
          "location",
          padding = { left = 0, right = 1 },
          separator = {},
        },
      }
      opts.sections.lualine_z = {}

      -- winbar
      opts.winbar = {
        lualine_a = {},
        lualine_b = {
          {
            "filetype",
            icon_only = true,
            padding = { left = 1, right = 0 },
          },
          {
            "filename",
            file_status = false,
            symbols = {},
            separator = { right = r_separator },
          },
        },
        lualine_c = {
          function()
            return require("lspsaga.symbol.winbar").get_bar() or ""
          end,
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }

      opts.inactive_winbar = {
        lualine_a = {},
        lualine_b = {
          {
            "filetype",
            icon_only = true,
            padding = { left = 1, right = 0 },
            color = { bg = "None" },
          },
          {
            "filename",
            file_status = false,
            symbols = {},
            separator = { right = "" },
            color = { bg = "None" },
          },
        },
        lualine_c = {
          function()
            return require("lspsaga.symbol.winbar").get_bar() or ""
          end,
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }

      return opts
    end,
  },
}
