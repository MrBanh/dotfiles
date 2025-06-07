local map = vim.keymap.set

map("n", "<leader>u?", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

-- themes
map("n", "<leader>ut", function()
  require("nvchad.themes").open()
end, { desc = "NvChad Themes" })

-- terminal
map({ "n", "t" }, "<C-/>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "Toggle terminal" })

map({ "n", "t" }, "<C-_>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "which_key_ignore" })
