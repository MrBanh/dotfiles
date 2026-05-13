vim.keymap.set("n", "<C-q>", function()
  vim.diagnostic.setqflist()
end, { silent = true, buffer = true, desc = "Add to Quickfix list" })
