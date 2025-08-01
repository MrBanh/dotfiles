return {
  'kawre/leetcode.nvim',
  cmd = 'Leet',
  build = ':TSUpdate html', -- if you have `nvim-treesitter` installed
  lazy = true,
  dependencies = {
    'nvim-telescope/telescope.nvim',
    -- "ibhagwan/fzf-lua",
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  opts = {
    lang = 'javascript',
    -- image_support = true,
  },
}
