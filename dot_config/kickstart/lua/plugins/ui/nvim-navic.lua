return {
  'SmiteshP/nvim-navic',
  event = 'LspAttach',
  opts = {
    highlight = true,
    lsp = {
      auto_attach = true,
    },
  },
  config = function(_, opts)
    require('nvim-navic').setup(opts)
  end,
}
