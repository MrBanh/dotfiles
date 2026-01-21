return {
  "zbirenbaum/copilot.lua",
  opts = {
    ---@type SuggestionConfig
    ---@diagnostic disable-next-line: missing-fields
    suggestion = {
      ---@diagnostic disable-next-line: missing-fields
      keymap = {
        accept = false,
        dismiss = "<C-c>",
      },
    },
    filetypes = {
      yaml = true,
      gitcommit = true,
    },
  },
}
