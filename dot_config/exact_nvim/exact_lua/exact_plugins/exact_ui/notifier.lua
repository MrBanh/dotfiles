return {
  "folke/snacks.nvim",
  opts = {
    notifier = {
      top_down = false,
    },
  },
  keys = {
    {
      "<leader>n",
      false,
    },
    {
      "<leader>Nn",
      function()
        Snacks.picker.notifications()
      end,
      desc = "Notification History",
    },
  },
}
