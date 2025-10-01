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
    },
    nes = {
      clear = {
        -- events that clear the current next edit suggestion
        events = { "TextChangedI", "InsertEnter" },
        esc = true, -- clear next edit suggestions when pressing <Esc>
      },
    },
  },
  keys = {
    { "<tab>", LazyVim.cmp.map({ "ai_nes" }, "<tab>"), mode = { "n" }, expr = true },
    {
      "<M-/>",
      function()
        require("sidekick.cli").toggle()
      end,
      mode = { "n", "x", "i", "t" },
      desc = "Sidekick Toggle",
    },
    {
      "<leader>an",
      function()
        require("sidekick.cli").select_tool()
      end,
      mode = { "n" },
      desc = "Sidekick New Tool",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").select_prompt()
      end,
      desc = "Sidekick Ask Prompt",
      mode = { "n", "v" },
    },
    {
      "<leader>aa",
      false,
    },
    {
      "<c-.>",
      false,
    },
  },
}
