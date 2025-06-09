return {
  'SmiteshP/nvim-navic',
  opts = {
    highlight = true,
    lsp = {
      auto_attach = true,
    },
  },
  config = function(_, opts)
    require('nvim-navic').setup(opts)
    vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
  end,
}
