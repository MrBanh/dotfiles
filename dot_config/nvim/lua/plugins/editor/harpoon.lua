return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  keys = function()
    local keys = {
      {
        "<leader>M",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon File",
      },
      {
        "<leader>m",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
    }
    return keys
  end,
}
