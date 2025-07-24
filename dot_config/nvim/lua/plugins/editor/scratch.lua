return {
  "LintaoAmons/scratch.nvim",
  dependencies = {
    { "ibhagwan/fzf-lua" }, --optional: if you want to use fzf-lua to pick scratch file. Recommanded, since it will order the files by modification datetime desc. (require rg)
  },
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
