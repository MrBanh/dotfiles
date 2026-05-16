return {
  "chrishrb/gx.nvim",
  lazy = true,
  keys = { { "gx", ":Browse<cr>", mode = { "n", "x" } } },
  cmd = { "Browse" },
  init = function()
    vim.g.netrw_nogx = 1 -- disable netrw gx
  end,
  config = true, -- default settings
  submodules = false, -- not needed, submodules are required only for tests
}
