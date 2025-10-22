return {
  "folke/sidekick.nvim",
  opts = {
    signs = {
      enabled = true, -- enable signs by default
      icon = " ",
    },
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
      win = {
        layout = "float", ---@type "float"|"left"|"bottom"|"top"|"right"
        float = {
          width = 0.6,
          height = 0.6,
        },
      },
    },
    nes = {
      enabled = function(buf)
        local ft = vim.bo[buf].filetype
        if ft == "markdown" then
          return false
        end
        return vim.g.sidekick_nes ~= false and vim.b.sidekick_nes ~= false
      end,
    },
  },
  keys = {
    {
      "<M-/>",
      function()
        require("sidekick.cli").toggle()
      end,
      mode = { "n", "x", "i", "t" },
      desc = "Sidekick Toggle",
    },
    {
      "<leader>ab",
      function()
        local file_path = vim.fn.expand("%")
        require("sidekick.cli").send({ msg = "@" .. file_path })
      end,
      desc = "Send current buffer",
    },
    {
      "<leader>ay",
      function()
        local file_path = vim.fn.expand("%")
        local ctx = require("sidekick.cli.context").ctx()
        require("sidekick.cli").send({ msg = "@" .. file_path .. "#L" .. ctx.range.from[1] .. "-" .. ctx.range.to[1] })
      end,
      mode = { "x" },
      desc = "Send current selection",
    },
    {
      "<c-.>",
      false,
    },
  },
}
