return {
  "LintaoAmons/scratch.nvim",
  dependencies = {
    { "folke/snacks.nvim" }, -- optional: if you want to pick scratch file by snacks picker
  },
  cmd = { "Scratch", "ScratchWithName", "ScratchOpen", "ScratchOpenFzf" },
  opts = {
    filetypes = { "lua", "js", "sh", "ts" },
    file_picker = "snacks", -- "fzflua" | "telescope" | "snacks" | nil
    filetype_details = {
      ["diffthis"] = {
        subdir = "diffthis", -- group scratch files under specific sub folder
      },
    },
  },
  keys = {
    { "<leader>Sn", "<cmd>Scratch<cr>", desc = "new scratch" },
    { "<leader>SN", "<cmd>ScratchWithName<cr>", desc = "new scratch (named)" },
    { "<leader>So", "<cmd>ScratchOpen<cr>", desc = "open scratch" },
  },
}
