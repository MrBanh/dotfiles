return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local icons = LazyVim.config.icons

    -- theme
    local auto = require("lualine.themes.auto")
    local lualine_modes = { "normal", "inactive" }
    for _, field in ipairs(lualine_modes) do
      if auto[field] and auto[field].c then
        auto[field].c.bg = "NONE"
      end
    end
    opts.options.theme = auto

    opts.options.disabled_filetypes = {
      "help",
      "toggleterm",
      "snacks_dashboard",
    }

    -- separators
    opts.options.component_separators = ""
    opts.options.section_separators = { left = "", right = "" }

    -- sections
    opts.sections.lualine_a = { { "mode", separator = { left = "", right = "" } } }
    opts.sections.lualine_c = {
      LazyVim.lualine.root_dir({
        ---@diagnostic disable-next-line: assign-type-mismatch
        cwd = true,
      }),
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
    opts.sections.lualine_z = {
      {
        function()
          return " " .. os.date("%R")
        end,
        separator = { left = "", right = "" },
      },
    }

    -- winbar
    opts.winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { LazyVim.lualine.pretty_path() },
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    }
    opts.inactive_winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { LazyVim.lualine.pretty_path() },
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    }

    if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })
      table.insert(opts.winbar.lualine_c, {
        symbols and symbols.get,
        cond = function()
          return vim.b.trouble_lualine ~= false and symbols.has()
        end,
      })
    end
    -- local icons = LazyVim.config.icons
    -- opts.sections.lualine_c = {
    --   LazyVim.lualine.root_dir(),
    --   {
    --     "diagnostics",
    --     symbols = {
    --       error = icons.diagnostics.Error,
    --       warn = icons.diagnostics.Warn,
    --       info = icons.diagnostics.Info,
    --       hint = icons.diagnostics.Hint,
    --     },
    --   },
    --   { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
    --   { LazyVim.lualine.pretty_path() },
    --   {
    --     "navic",
    --     color_correction = "static",
    --     navic_opts = {
    --       separator = " > ",
    --       icons_enabled = true,
    --       highlight = true,
    --       icons = LazyVim.config.icons.kinds,
    --       lazy_update_context = true,
    --       safe_output = true,
    --     },
    --   },
    -- }

    return opts
  end,
}
