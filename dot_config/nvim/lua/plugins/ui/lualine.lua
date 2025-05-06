return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local auto = require("lualine.themes.auto")
    local lualine_modes = { "normal", "inactive" }
    for _, field in ipairs(lualine_modes) do
      if auto[field] and auto[field].c then
        auto[field].c.bg = "NONE"
      end
    end
    opts.options.theme = auto
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
