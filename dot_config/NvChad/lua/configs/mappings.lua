local set = vim.keymap.set
local opts = { noremap = true, silent = true }

set({ "n", "v" }, "H", "^", opts)
set({ "n", "v" }, "L", "$", opts)

-- Paste without overwriting
set("v", "p", "P", opts)

-- Do not overwrite when using change command
set("n", "c", [["_c]], opts)
set("v", "c", [["_c]], opts)

-- Better escape
set("i", "jk", "<Esc>", opts)

-- better indent handling
set("v", "<", "<gv", opts)
set("v", ">", ">gv", opts)

-- move text up and down
set("v", "J", ":m .+1<CR>==", opts)
set("v", "K", ":m .-2<CR>==", opts)
set("x", "J", ":move '>+1<CR>gv-gv", opts)
set("x", "K", ":move '<-2<CR>gv-gv", opts)

-- regex helpers
set("c", [[\\*]], [[\(.*\)]])
set("c", [[\\-]], [[\(.\{-}\)]])

-- Yank to clipboard
set({ "n", "v" }, "<leader>Y", [["+y]], vim.tbl_extend("force", opts, { desc = "[Y]ank selected to clipboard" }))

-- paste from system clipboard
set({ "n", "v" }, "<leader>P", [["+p]], vim.tbl_extend("force", opts, { desc = "[P]aste from clipboard" }))

-- source lua file
set("n", "<C-w>%", "<Cmd>source %<CR>")

-- exit terminal mode while in terminal
set("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- Browser search bar (see autocmds.lua)
vim.keymap.set("n", "<leader>sO", ":SearchInBrowser<CR>", {
  desc = "Search in browser",
})
