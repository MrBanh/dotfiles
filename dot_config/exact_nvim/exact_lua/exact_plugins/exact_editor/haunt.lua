local prefix = "<leader>h"

return {
  "TheNoeTrevino/haunt.nvim",
  ---@class HauntConfig
  opts = {
    sign = "󱙝",
    sign_hl = "DiagnosticInfo",
    virt_text_hl = "HauntAnnotation",
    annotation_prefix = " 󰆉 ",
    annotation_suffix = "",
    line_hl = nil,
    virt_text_pos = "eol",
    data_dir = nil,
    per_branch_bookmarks = true,
    picker = "auto",
    picker_keys = {
      delete = { key = "<C-x>", mode = { "n", "i" } },
      edit_annotation = { key = "a", mode = { "n" } },
    },
  },
  keys = {
    {
      prefix .. "a",
      function()
        require("haunt.api").annotate()
      end,
      desc = "Annotate",
    },
    {
      prefix .. "t",
      function()
        require("haunt.api").toggle_annotation()
      end,
      desc = "Toggle annotation",
    },
    {
      prefix .. "T",
      function()
        require("haunt.api").toggle_all_lines()
      end,
      desc = "Toggle all annotations",
    },
    {
      prefix .. "d",
      function()
        require("haunt.api").delete()
      end,
      desc = "Delete bookmark",
    },
    {
      prefix .. "C",
      function()
        require("haunt.api").clear_all()
      end,
      desc = "Delete all bookmarks",
    },
    -- move
    {
      prefix .. "p",
      function()
        require("haunt.api").prev()
      end,
      desc = "Previous bookmark",
    },
    {
      prefix .. "n",
      function()
        require("haunt.api").next()
      end,
      desc = "Next bookmark",
    },
    {
      prefix .. "l",
      function()
        require("haunt.picker").show()
      end,
      desc = "Show Picker",
    },
    {
      prefix .. "q",
      function()
        require("haunt.api").to_quickfix()
      end,
      desc = "Send Hauntings to QF List",
    },
    {
      prefix .. "Q",
      function()
        require("haunt.api").to_quickfix({ current_buffer = true })
      end,
      desc = "Send Hauntings to QF List (all)",
    },
    {
      prefix .. "y",
      function()
        require("haunt.api").yank_locations({ current_buffer = true })
      end,
      desc = "Send Hauntings to Clipboard",
    },
    {
      prefix .. "Y",
      function()
        require("haunt.api").yank_locations()
      end,
      desc = "Send Hauntings to Clipboard (all)",
    },
  },
  init = function()
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({
        { prefix, group = "haunt", icon = { icon = "󱙝 " } },
      })
    end
  end,
}
