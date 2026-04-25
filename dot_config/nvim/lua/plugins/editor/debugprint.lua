local keymap_prefix = "<leader>p"

return {
  "andrewferrier/debugprint.nvim",
  version = "*",
  dependencies = {
    "folke/snacks.nvim",
  },
  opts = {
    keymaps = {
      normal = {
        plain_below = keymap_prefix .. "p",
        plain_above = keymap_prefix .. "P",
        variable_below = keymap_prefix .. "v",
        variable_above = keymap_prefix .. "V",
        variable_below_alwaysprompt = "",
        variable_above_alwaysprompt = "",
        surround_plain = keymap_prefix .. "sp",
        surround_variable = keymap_prefix .. "sv",
        surround_variable_alwaysprompt = "",
        textobj_below = keymap_prefix .. "o",
        textobj_above = keymap_prefix .. "O",
        textobj_surround = keymap_prefix .. "so",
        toggle_comment_debug_prints = keymap_prefix .. "c",
        delete_debug_prints = keymap_prefix .. "d",
      },
      insert = {
        plain = "<C-G>p",
        variable = "<C-G>v",
      },
      visual = {
        variable_below = keymap_prefix .. "v",
        variable_above = keymap_prefix .. "V",
      },
    },
  },
  config = function(_, opts)
    require("debugprint").setup(opts)
    require("which-key").add({
      {
        keymap_prefix,
        group = "print",
        icon = { icon = "󱞆 " },
      },
    })
  end,
}
