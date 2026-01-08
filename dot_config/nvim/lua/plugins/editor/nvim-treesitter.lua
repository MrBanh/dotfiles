return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {},
    config = function(_, opts)
      vim.treesitter.language.register("markdown", "opencode")
      vim.filetype.add({
        extension = { lyaml = "yaml", git = "git", keymap = "dts" },
      })
      require("nvim-treesitter").setup(opts)
    end,
  },
  {
    "MeanderingProgrammer/treesitter-modules.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      -- Coming with Nvim 12: https://github.com/neovim/neovim/pull/34011/files
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<M-o>",
          node_incremental = "<M-o>",
          scope_incremental = "<M-O>",
          node_decremental = "<M-i>",
        },
      },
    },
  },
}
