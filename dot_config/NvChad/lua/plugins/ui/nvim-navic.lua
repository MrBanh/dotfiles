  return {
    "SmiteshP/nvim-navic",
    event = "LspAttach",
    opts = {
      highlight = true,
      lsp = {
        auto_attach = true
      }
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "navic")

      require("nvim-navic").setup(opts)
      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end,
  }
