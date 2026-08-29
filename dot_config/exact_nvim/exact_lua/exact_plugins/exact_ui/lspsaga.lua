-- Do NOT swap to navic or trouble
--- trouble: does not work in splits; both split shows same breadcrumbs
--- navic: in splits, breadcrumbs from other windows appears sometimes
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
  },
}
