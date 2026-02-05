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
        code_action = "󱐌 ",
      },
      symbol_in_winbar = {
        enable = false,
        folder_level = 0,
        show_file = false,
      },
      code_action = {
        extend_gitsigns = true,
      },
      rename = {
        in_select = false,
        auto_save = true,
        keys = {
          select = "<Tab>",
          quit = "<C-c>",
        },
      },
    },
    keys = {
      {
        "<leader>rn",
        function()
          require("lspsaga.rename"):lsp_rename()
        end,
        desc = "Rename",
        mode = { "n", "v" },
      },
      {
        "<leader>rN",
        function()
          require("lspsaga.rename"):lsp_rename({ "++project" })
        end,
        desc = "Rename (project-wide)",
        mode = { "n", "v" },
      },
    },
  },
}
