return {
  "MagicDuck/grug-far.nvim",
  opts = {
    headerMaxWidth = 80,

    keymaps = {
      -- :h grug-far-opts
      historyOpen = { n = "<localleader>h" },
    },
  },
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sr",
      function()
        local grug = require("grug-far")

        local search = vim.fn.expand("<cword>")
        -- local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")

        grug.open({
          transient = true,
          prefills = {
            search = search,
            -- filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            flags = "-i",
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace",
    },
  },
}
