return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      actions = {
        find_in_project = function(picker, item)
          picker:close()
          local dir = item.file
          Snacks.picker.files({
            dirs = { dir },
          })
        end,
      },
      sources = {
        projects = {
          dev = { "~/dev", "~/projects", "~/src", "~/.config" },
        },
      },
    },
  },
  keys = {
    {
      "<leader>fp",
      function()
        Snacks.picker.projects({
          confirm = "find_in_project",
        })
      end,
      desc = "Find in Projects",
    },
    {
      "<leader>fP",
      function()
        Snacks.picker.zoxide({
          confirm = "find_in_project",
        })
      end,
      desc = "Find in Projects (Zoxide)",
    },
    {
      "<leader>qp",
      function()
        Snacks.picker.projects({})
      end,
      desc = "Load Projects Session",
    },
    {
      "<leader>qP",
      function()
        Snacks.picker.zoxide({})
      end,
      desc = "Load Projects Session (Zoxide)",
    },
  },
}
