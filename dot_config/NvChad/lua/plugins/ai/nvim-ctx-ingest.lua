vim.keymap.set("n", "<leader>ai", ":CtxIngest<CR>", {
  desc = "Ctx Ingest: provide context to AI",
})

return {
  "0xrusowsky/nvim-ctx-ingest",
  lazy = true,
  dependencies = {
    -- "mini.icons",
    "nvim-web-devicons",
  },
  cmd = { "CtxIngest" },
  config = function()
    require("nvim-ctx-ingest").setup {}
  end,
}
