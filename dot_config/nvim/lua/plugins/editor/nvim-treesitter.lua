return {
  "nvim-treesitter/nvim-treesitter",
  opts = {},
  config = function(_, opts)
    vim.filetype.add({
      extension = { lyaml = "yaml", git = "git" },
    })
    require("nvim-treesitter").setup(opts)
  end,
}
