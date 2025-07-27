return {
  'nvimdev/lspsaga.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons', -- optional
  },
  config = function()
    require('lspsaga').setup {
      lightbulb = {
        enable = true,
        virtual_text = false, -- disables just the one at the end of the line
      },
      ui = {
        code_action = '󱐌',
      },
      symbol_in_winbar = {
        folder_level = 0,
      },
    }
  end,
}
