return {
  "ruifm/gitlinker.nvim",
  keys = {
    {
      "<leader>go",
      function()
        require("gitlinker").get_buf_range_url("n")
      end,
      silent = true,
      desc = "[G]it [O]pen in browser",
    },
    {
      "<leader>go",
      function()
        require("gitlinker").get_buf_range_url("v")
      end,
      mode = "x",
      desc = "[G]it [O]pen in browser",
    },
  },
  opts = {
    mappings = nil,
    opts = {
      add_current_line_on_normal_mode = true,
      print_url = false,
      action_callback = function(...)
        return require("gitlinker.actions").open_in_browser(...)
      end,
    },
  },
}
