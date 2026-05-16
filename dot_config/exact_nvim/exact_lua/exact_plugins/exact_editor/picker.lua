return {
  "folke/snacks.nvim",
  opts = {
    -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#%EF%B8%8F-config
    picker = {
      formatters = {
        file = {
          filename_first = true,
          ---@type "left"|"center"|"right"
          truncate = "center",
          min_width = 80,
        },
      },
      hidden = true,
      layouts = {
        custom_ivy = {
          layout = {
            box = "vertical",
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.4,
            border = "top",
            title = " {title} {live} {flags}",
            title_pos = "left",
            { win = "input", height = 1, border = "none" },
            {
              box = "horizontal",
              { win = "list", border = true },
              { win = "preview", title = "{preview}", width = 0.5, border = true, title_pos = "left" },
            },
          },
        },
      },
      layout = {
        cycle = false,
        preset = "custom_ivy",
      },
      matcher = {
        fuzzy = true,
        smartcase = true,
        ignorecase = true,
        sort_empty = false,
        filename_bonus = true,
        file_pos = true,
        cwd_bonus = true,
        frecency = true,
        history_bonus = true,
      },
      win = {
        input = {
          keys = {
            ["<a-d>"] = false,
            ["<a-f>"] = false,
            ["<a-h>"] = false,
            ["<a-i>"] = false,
            ["<a-r>"] = false,
            ["<a-m>"] = false,
            ["<a-p>"] = false,
            ["<a-w>"] = false,

            ["<localleader>d"] = { "inspect", mode = { "n" } },
            ["<localleader>f"] = { "toggle_follow", mode = { "n" } },
            ["<localleader>h"] = { "toggle_hidden", mode = { "n" } },
            ["<localleader>i"] = { "toggle_ignored", mode = { "n" } },
            ["<localleader>r"] = { "toggle_regex", mode = { "n" } },
            ["<localleader>m"] = { "toggle_maximize", mode = { "n" } },
            ["<localleader>p"] = { "toggle_preview", mode = { "n" } },
            ["<localleader>w"] = { "cycle_win", mode = { "n" } },

            -- causes all pickers to close, e.g. Explorer + ivy, pressing <Esc in ivy closes both
            -- ["<Esc>"] = { "close", mode = { "n", "i" } },

            ["<LocalLeader>C"] = { "toggle_cwd", mode = { "n", "i" } },
            ["<C-j>"] = { "focus_list", mode = { "i", "n" } },
            ["<C-l>"] = { "focus_preview", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<a-d>"] = false,
            ["<a-f>"] = false,
            ["<a-h>"] = false,
            ["<a-i>"] = false,
            ["<a-m>"] = false,
            ["<a-p>"] = false,
            ["<a-w>"] = false,

            ["<localleader>d"] = "inspect",
            ["<localleader>f"] = "toggle_follow",
            ["<localleader>h"] = "toggle_hidden",
            ["<localleader>i"] = "toggle_ignored",
            ["<localleader>m"] = "toggle_maximize",
            ["<localleader>p"] = "toggle_preview",
            ["<localleader>w"] = "cycle_win",

            ["<LocalLeader>C"] = { "toggle_cwd", mode = { "n", "i" } },

            ["<C-k>"] = { "focus_input", mode = { "i", "n" } },
            ["<C-l>"] = { "focus_preview", mode = { "i", "n" } },
          },
          wo = {
            number = true,
            relativenumber = true,
          },
        },
        preview = {
          keys = {
            ["<a-w>"] = false,
            ["<localleader>w"] = "cycle_win",

            ["<C-k>"] = { "focus_input", mode = { "i", "n" } },
            ["<C-h>"] = { "focus_list", mode = { "i", "n" } },
          },
        },
      },
      sources = {
        files = {
          hidden = true,
        },
      },
      toggles = {
        follow = " follow",
        hidden = " hidden",
        ignored = " ignored",
        modified = " modified",
        regex = { icon = " regex", value = false },
      },
    },
  },
  keys = {
    {
      "<leader>sP",
      function()
        Snacks.picker.lazy()
      end,
      desc = "Search for Plugin Spec",
    },
  },
}
