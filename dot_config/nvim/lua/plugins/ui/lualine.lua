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
}

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local icons = LazyVim.config.icons

    -- https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
    -- local custom_theme = require("lualine.themes.ayu_mirage")
    local custom_theme = require("lualine.themes.auto")
    local lualine_modes = { "normal", "inactive" }
    for _, field in ipairs(lualine_modes) do
      if custom_theme[field] and custom_theme[field].c then
        custom_theme[field].c.bg = "NONE"
      end
    end

    opts.options.theme = custom_theme

    opts.options.disabled_filetypes.winbar = disabled_filetypes

    -- separators
    opts.options.component_separators = ""
    opts.options.section_separators = { left = "", right = "" }

    -- sections: https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#available-components
    opts.sections.lualine_a = { { "mode", separator = { left = "", right = "" } } }
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
      lualine_b = {
        {
          "filetype",
          icon_only = true,
          padding = { left = 1, right = 0 },
          separator = { left = "" },
        },
        {
          "filename",
          file_status = false,
          symbols = {},
        },
      },
      lualine_c = {},
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
          separator = { left = "" },
        },
        {
          "filename",
          file_status = false,
          symbols = {},
        },
      },
      lualine_c = {},
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

    return opts
  end,
}
