require("which-key").add {
  "<leader>S",
  group = "Scratch",
  icon = { icon = "󱞁 " },
}

return {
  "LintaoAmons/scratch.nvim",
  cmd = { "Scratch", "ScratchWithName", "ScratchOpen", "ScratchOpenFzf" },
  keys = {
    { "<leader>Sn", "<cmd>Scratch<cr>", desc = "new scratch" },
    { "<leader>SN", "<cmd>ScratchWithName<cr>", desc = "new scratch (named)" },
    { "<leader>So", "<cmd>ScratchOpen<cr>", desc = "open scratch" },
    { "<leader>Sg", "<cmd>ScratchOpenFzf<cr>", desc = "open scratch (fzf)" },
  },
  opts = {
    filetypes = { "lua", "js", "sh", "ts" },
  },
}
