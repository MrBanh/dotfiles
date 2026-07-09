local prefix = "<leader>h"

return {
  {
    "TheNoeTrevino/haunt.nvim",
    ---@class HauntConfig
    opts = {
      sign = "󱙝",
      sign_hl = "DiagnosticInfo",
      virt_text_hl = "HauntAnnotation",
      annotation_prefix = " 󱙝 ",
      annotation_suffix = "",
      line_hl = nil,
      virt_text_pos = "eol", ---@type "eol" | "above"
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
        mode = { "n" },
      },
      {
        prefix .. "a",
        function()
          local text = table.concat(require("user.utils").get_visual_selection_text(), "\n")
          require("haunt.api").annotate(string.gsub(text, "%s+", " "))
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end,
        desc = "Annotate",
        mode = { "x" },
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
        prefix .. "D",
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
  },
  {
    "folke/sidekick.nvim",
    cmd = "Sidekick",
    ---@class sidekick.Config
    opts = {
      cli = {
        prompts = {
          haunt_all = function()
            return require("haunt.sidekick").get_locations()
          end,
          haunt_buffer = function()
            return require("haunt.sidekick").get_locations({ current_buffer = true })
          end,
        },
      },
    },
  },
}
