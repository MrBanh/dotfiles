local set = vim.keymap.set
local del = vim.keymap.del
local opts = { noremap = true, silent = true }

-- Unmap the <C-x> keybinding set by harpoon community
del("n", "<C-x>")

set({ "i", "n", "t" }, "<c-/>", "<Esc><cmd>ToggleTerm<cr>", {
  desc = "Toggleterm",
})
set({ "i", "n", "t" }, "<c-_>", "<Esc><cmd>ToggleTerm<cr>", { desc = "which_key_ignore" })

set({ "n", "v" }, "H", "^", opts)
set({ "n", "v" }, "L", "$", opts)

-- Paste without overwriting
set("v", "p", "P", opts)

-- Do not overwrite when using change command
set("n", "c", [["_c]], opts)
set("v", "c", [["_c]], opts)

-- Jump up/down while keeping cursor centered
set("n", "<C-u>", "<C-u>zz")
set("n", "<C-d>", "<C-d>zz")

-- Joins without cursor moving
set("n", "J", "mzJ`z")

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

-- terminal
set("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })
