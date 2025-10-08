return {
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },

      -- {"nvim-telescope/telescope.nvim"},
      -- { "ibhagwan/fzf-lua" },
      -- { "folke/snacks.nvim" },
    },
    event = "LspAttach",
    opts = {
      backend = "vim",
      picker = {
        -- "snacks",
        -- opts = {
        --   layout = {
        --     preset = "default",
        --     cycle = false,
        --   },
        -- },

        "buffer",
        opts = {
          hotkeys = true, -- Enable hotkeys for the buffer picker to quickly select an action

          -- sequential = a, b, c...
          -- text_based = "Fix all" => "f", "Fix others" => "o" (first non assigned letter of the action)
          -- text_diff_based = "Fix all" => "fa", "Fix others" => "fo" smarter than text_based
          hotkeys_mode = "sequential", -- "text_diff_based" | "text_based" | "sequential"
          auto_preview = true, -- Enable auto preview of the code action
          position = "cursor", -- "cursor" or "center"
          winborder = "rounded", -- Set the window border style ("single", "rounded", "solid", etc.)
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- change a keymap
      keys[#keys + 1] = {
        "<leader>ca",
        function()
          require("tiny-code-action").code_action({})
        end,
        desc = "Code Action",
        mode = { "n", "v" },
        has = "codeAction",
      }

      -- disable a keymap
      -- keys[#keys + 1] = { "K", false }

      -- add a keymap
      -- keys[#keys + 1] = { "H", "<cmd>echo 'hello'<cr>" }
    end,
  },
}
