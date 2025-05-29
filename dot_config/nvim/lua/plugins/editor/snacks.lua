return {
  "folke/snacks.nvim",
  opts = {
    styles = {
      -- This keeps the image on the top right corner
      snacks_image = {
        relative = "editor",
        col = -1,
      },
    },
    image = {
      enabled = false,
      doc = {
        float = true,
        inline = true,
      },
      cache = nil,
    },
    notifier = {
      top_down = false,
    },
    -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#%EF%B8%8F-config
    picker = {
      layout = {
        preset = "ivy",
        cycle = false,
      },
      matcher = {
        fuzzy = true, -- use fuzzy matching
        smartcase = true, -- use smartcase
        ignorecase = true, -- use ignorecase
        sort_empty = false, -- sort results when the search string is empty
        filename_bonus = true, -- give bonus for matching file names (last part of the path)
        file_pos = true, -- support patterns like `file:line:col` and `file:line`
        -- the bonusses below, possibly require string concatenation and path normalization,
        -- so this can have a performance impact for large lists and increase memory usage
        cwd_bonus = true, -- give bonus for matching files in the cwd
        frecency = true, -- frecency bonus
        history_bonus = true, -- give more weight to chronological order
      },
      win = {
        -- when focus is on input box above list
        input = {
          keys = {
            ["<leader>`"] = { "toggle_cwd", mode = { "n", "i" } },
            ["<Esc>"] = { "close", mode = { "n", "i" } }, -- close picker instead of going to normal mode
            ["<c-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<c-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
            ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
            ["<c-w><Tab>"] = { "focus_preview", desc = "Focus Preview" },
          },
        },
        -- when focus in on list
        list = {
          keys = {
            ["<leader>`"] = { "toggle_cwd", mode = { "n", "i" } },
            ["<c-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<c-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
            ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
            ["<c-w><Tab>"] = { "focus_preview", desc = "Focus Preview" },
          },
        },
      },
      sources = {
        explorer = {
          auto_close = true,
          layout = { preset = "default", preview = true },
          win = {
            input = {
              keys = {
                ["`"] = "tcd",
                ["<leader>`"] = { "toggle_cwd", mode = { "n", "i" } },
                ["<c-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
                ["<c-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
                ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
                ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
                ["<c-w><Tab>"] = { "focus_preview", desc = "Focus Preview" },
              },
            },
            list = {
              keys = {
                ["<c-/>"] = "terminal",
                ["`"] = "tcd",
                ["<leader>`"] = { "toggle_cwd", mode = { "n", "i" } },
                ["<c-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
                ["<c-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
                ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
                ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
                ["<c-w><Tab>"] = { "focus_preview", desc = "Focus Preview" },
              },
            },
          },
        },
      },
    },
    scroll = {
      enabled = false,
    },
    terminal = {
      win = {
        style = {
          border = "rounded",
          -- position = "float",
          -- backdrop = 60,
          -- height = 0.9,
          -- width = 0.9,
          -- zindex = 50,
        },
      },
    },
  },
}
