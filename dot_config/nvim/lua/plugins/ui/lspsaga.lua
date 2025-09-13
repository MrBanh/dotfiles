return {
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
    },
    opts = {
      lightbulb = {
        enable = false,
        sign = false,
        virtual_text = false, -- disables just the one at the end of the line
      },
      ui = {
        code_action = "󱐌",
      },
      symbol_in_winbar = {
        enable = false,
        folder_level = 0,
        show_file = false,
      },
      code_action = {
        extend_gitsigns = true,
      },
    },
  },

  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function()
  --     local keys = require("lazyvim.plugins.lsp.keymaps").get()
  --     -- change a keymap
  --     keys[#keys + 1] = {
  --       "<leader>ca",
  --       ":Lspsaga code_action<CR>",
  --       desc = "Code Action",
  --       mode = { "n", "v" },
  --       has = "codeAction",
  --     }
  --   end,
  -- },
}
