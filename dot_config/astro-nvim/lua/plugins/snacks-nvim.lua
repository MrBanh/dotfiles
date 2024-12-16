-- https://github.com/folke/snacks.nvim?tab=readme-ov-file
-- PR for adding snacks.nvim to astro: https://github.com/AstroNvim/astrocommunity/pull/1264

return {
  "folke/snacks.nvim",
  opts = {
    gitbrowse = {},
  },
  keys = {
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
  },
}
