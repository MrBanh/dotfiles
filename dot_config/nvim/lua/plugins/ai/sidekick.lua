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
      "<c-.>",
      false,
    },
    {
      "<leader>af",
      false,
    },
    {
      "<leader>ab",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      desc = "Send Current Buffer",
    },
  },
}
