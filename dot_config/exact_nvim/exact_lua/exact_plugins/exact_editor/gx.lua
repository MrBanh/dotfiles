return {
  "chrishrb/gx.nvim",
  lazy = true,
  cmd = { "Browse" },
  init = function()
    vim.g.netrw_nogx = 1 -- disable netrw gx
  end,
  keys = {
    { "gx", ":Browse<cr>", mode = { "n", "x" } },
    {
      "<leader>so",
      function()
        vim.ui.input({ prompt = "Search: " }, function(input)
          if input then
            vim.cmd("Browse " .. input)
          end
        end)
      end,
      mode = { "n" },
      desc = "Search in browser",
    },
  },
  config = true, -- default settings
}
