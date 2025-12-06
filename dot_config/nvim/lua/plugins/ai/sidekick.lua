local enable_sidekick_cli = true

return {
  {
    "sudo-tee/opencode.nvim",
    enabled = not enable_sidekick_cli,
  },

  {
    "folke/sidekick.nvim",
    opts = {
      signs = {
        enabled = true, -- enable signs by default
        icon = " ",
      },
      cli = {
        mux = {
          backend = "tmux",
          enabled = vim.fn.executable("tmux") == 1,
        },
        win = {
          layout = vim.g.floating_terminal and "float" or "right", ---@type "float"|"left"|"bottom"|"top"|"right"
          float = {
            width = 0.6,
            height = 0.6,
          },
        },
      },
      nes = {
        enabled = function(buf)
          local ft = vim.bo[buf].filetype
          if ft == "markdown" then
            return false
          end
          return vim.g.sidekick_nes ~= false and vim.b.sidekick_nes ~= false
        end,
      },
    },
    keys = enable_sidekick_cli and {
      {
        "<M-/>",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
    } or {
      {
        "<c-.>",
        false,
      },
      {
        "<leader>aa",
        false,
      },
      {
        "<leader>as",
        false,
      },
      {
        "<leader>ad",
        false,
      },
      {
        "<leader>at",
        false,
      },
      {
        "<leader>af",
        false,
      },
      {
        "<leader>av",
        false,
      },
      {
        "<leader>ap",
        false,
      },
    },
  },
}
