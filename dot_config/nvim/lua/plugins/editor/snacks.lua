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
        frecency = true,
      },
      sources = {
        explorer = {
          auto_close = true,
          layout = { preset = "default", preview = true },
          win = {
            input = {
              keys = {
                ["`"] = "tcd",
                ["<c-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
                ["<c-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
                ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
                ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
              },
            },
            list = {
              keys = {
                ["<c-/>"] = "terminal",
                ["`"] = "tcd",
                ["<c-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
                ["<c-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
                ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
                ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
              },
            },
          },
        },
      },
      win = {
        -- when focus is on input box above list
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } }, -- close picker instead of going to normal mode
            ["<c-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<c-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
            ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
          },
        },
        -- when focus in on list
        list = {
          keys = {
            ["<c-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<c-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
            ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
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
        },
      },
    },
  },
}
