---@type "markview" | "render-markdown"
local renderer = "markview"
local ft = { "md", "markdown", "opencode_output" }

return {
  {
    "OXY2DEV/markview.nvim",
    enabled = renderer == "markview",
    lazy = false, -- already lazy loaded
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local presets = require("markview.presets")

      -- override presets
      local heading_preset = "glow"
      for i = 1, 6 do
        presets.headings[heading_preset]["heading_" .. i].sign = ""
      end

      require("markview").setup({
        ---@diagnostic disable-next-line: missing-fields
        markdown = {
          headings = presets.headings.glow,
          tables = presets.tables.rounded,
          ---@diagnostic disable-next-line: missing-fields
          code_blocks = {
            style = "simple",
          },
        },
        preview = {
          enable = true,
          map_gx = true,
          -- hybrid_modes = { "n" },
          edit_range = { 0, 0 },
          filetypes = ft,
          ignore_buftypes = {},
          -- Optional, Use `condition()` to ignore other `nofile` buffers(e.g. LSP hover buffer, codecompanion, etc)
          condition = function(buffer)
            local buf_ft, buf_bt = vim.bo[buffer].ft, vim.bo[buffer].bt

            if buf_bt == "nofile" and vim.tbl_contains(ft, buf_ft) then
              return true
            elseif buf_bt == "nofile" then
              return false
            else
              return true
            end
          end,
        },
        ---@diagnostic disable-next-line: missing-fields
        markdown_inline = {
          ---@diagnostic disable-next-line: missing-fields
          checkboxes = {
            checked = { text = "󰱒", hl = "MarkviewCheckboxChecked", scope_hl = "MarkviewCheckboxChecked" },
            unchecked = { text = "󰄱", hl = "MarkviewCheckboxUnchecked", scope_hl = "MarkviewCheckboxUnchecked" },
            ["~"] = { text = "󰡖", hl = "MarkviewCheckboxPending", scope_hl = "MarkviewCheckboxPending" },
          },
          images = {
            enable = true,

            default = {
              icon = "󰥶 ",
              hl = "MarkviewImage",
            },

            ["%.svg$"] = { icon = "󰜡 " },
            ["%.png$"] = { icon = "󰸭 " },
            ["%.jpg$"] = { icon = "󰈥 " },
            ["%.gif$"] = { icon = "󰵸 " },
            ["%.pdf$"] = { icon = " " },
          },
        },
      })
    end,
  },

  -- Lazy: https://www.lazyvim.org/extras/lang/markdown#render-markdownnvim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = renderer == "render-markdown",
    lazy = true,
    ft = ft,
    opts = {
      -- Filetypes this plugin will run on.
      file_types = ft,
      heading = {
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        position = "inline",
        width = "block",
        left_pad = 2,
        right_pad = 2,
      },
      html = {
        comment = {
          conceal = false,
        },
      },
      code = {
        -- right_pad = 0,
        -- width = "block",
        -- language_border = " ",
        language_border = " ",
        language_right = "",
        sign = true,
      },
      checkbox = {
        enabled = true,
        custom = {
          todo = { raw = "[~]", rendered = "󰡖 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
        },
        checked = {
          scope_highlight = "RenderMarkdownChecked",
        },
      },
      latex = {
        enabled = false,
      },
    },
  },
}
