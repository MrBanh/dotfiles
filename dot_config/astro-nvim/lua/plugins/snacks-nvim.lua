-- https://github.com/folke/snacks.nvim?tab=readme-ov-file
-- PR for adding snacks.nvim to astro: https://github.com/AstroNvim/astrocommunity/pull/1264

return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    indent = { enabled = true },
    input = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
  },
  keys = {
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
  },
  specs = {
    -- { "rcarriga/nvim-notify", enabled = false },
    { "lukas-reineke/indent-blankline.nvim", enabled = false },
  },
  init = function()
    -- https://github.com/folke/snacks.nvim/blob/main/docs/debug.md
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.dim():map "<leader>ud"
      end,
    })
  end,
}
