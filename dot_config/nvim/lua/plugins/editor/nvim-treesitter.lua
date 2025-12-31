return {
  "nvim-treesitter/nvim-treesitter",
  opts = {},
  config = function(_, opts)
    vim.treesitter.language.register("markdown", "opencode")
    vim.filetype.add({
      extension = { lyaml = "yaml", git = "git", keymap = "dts" },
    })
    require("nvim-treesitter").setup(opts)
  end,
}
