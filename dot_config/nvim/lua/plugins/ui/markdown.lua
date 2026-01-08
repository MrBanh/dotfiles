---@type "markview" | "render-markdown"
local renderer = "render-markdown"
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
          ---@diagnostic disable-next-line: missing-fields
          list_items = {
            enable = true,
            indent_size = 1,
            shift_width = 1,
          },
          metadata_minus = {
            enable = false,
          },
          metadata_plus = {
            enable = false,
          },
        },
        preview = {
          enable = true,
          map_gx = true,
          edit_range = { 0, 0 },
          filetypes = ft,
          ignore_buftypes = {},

          -- modes where preview will be shown
          modes = { "n" }, -- n, no, c
          hybrid_modes = { "n" }, -- don't preview in current line + child lines
          linewise_hybrid_mode = true, -- true current line hybrid controlled by edit_range, false all lines hybrid

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
        yaml = {
          enable = true,
          properties = {
            enable = true,

            data_types = {
              ["text"] = {
                text = "󰗊 ",
                hl = "MarkviewPalette4Sign",
              },
              ["list"] = {
                text = "󰝖 ",
                hl = "MarkviewPalette5Sign",
              },
              ["number"] = {
                text = " ",
                hl = "MarkviewPalette6Sign",
              },
              ["checkbox"] = {
                ---@diagnostic disable
                text = function(_, item)
                  return item.value == "true" and "󰄲 " or "󰄱 "
                end,
                ---@diagnostic enable
                hl = "MarkviewPalette6Sign",
              },
              ["date"] = {
                text = "󰃭 ",
                hl = "MarkviewPalette2Sign",
              },
              ["date_&_time"] = {
                text = "󰥔 ",
                hl = "MarkviewPalette3Sign",
              },
            },

            default = {
              use_types = true,

              border_top = nil,
              border_middle = nil,
              border_bottom = nil,

              border_hl = nil,
            },

            ["^tags$"] = {
              use_types = false,

              text = "󰓹 ",
              hl = "MarkviewPalette0Sign",
            },
            ["^aliases$"] = {
              match_string = "^aliases$",
              use_types = false,

              text = "󱞫 ",
              hl = "MarkviewPalette2Sign",
            },
            ["^cssclasses$"] = {
              match_string = "^cssclasses$",
              use_types = false,

              text = " ",
              hl = "MarkviewPalette3Sign",
            },

            ["^publish$"] = {
              match_string = "^publish$",
              use_types = false,

              text = "󰅧 ",
              hl = "MarkviewPalette5Sign",
            },
            ["^permalink$"] = {
              match_string = "^permalink$",
              use_types = false,

              text = " ",
              hl = "MarkviewPalette2Sign",
            },
            ["^description$"] = {
              match_string = "^description$",
              use_types = false,

              text = "󰋼 ",
              hl = "MarkviewPalette0Sign",
            },
            ["^image$"] = {
              match_string = "^image$",
              use_types = false,

              text = "󰋫 ",
              hl = "MarkviewPalette4Sign",
            },
            ["^cover$"] = {
              match_string = "^cover$",
              use_types = false,

              text = "󰹉 ",
              hl = "MarkviewPalette2Sign",
            },
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
        icons = { "󰼏 ", "󰎨 ", "󰼑 ", "󰎲 ", "󰼓 ", "󰎴 " },
        position = "inline",
        width = "block",
        left_pad = 1,
        right_pad = 1,
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
          todo = { raw = "[~]", rendered = "󰡖 ", highlight = "Orange", scope_highlight = "Orange" },
        },
        checked = {
          scope_highlight = "@markup.list.checked",
        },
        unchecked = {
          highlight = "Red",
          scope_highlight = "Red",
        },
      },
      bullet = {
        icons = { "○", "●" },
      },
      latex = {
        enabled = false,
      },
    },
  },
}
