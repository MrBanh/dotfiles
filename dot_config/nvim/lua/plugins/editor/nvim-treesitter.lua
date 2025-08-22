return {
  "nvim-treesitter/nvim-treesitter",
  opts = {},
  config = function(_, opts)
    vim.filetype.add({
      extension = { lyaml = "yaml" },
    })
    require("nvim-treesitter.configs").setup(opts)
  end,
}
