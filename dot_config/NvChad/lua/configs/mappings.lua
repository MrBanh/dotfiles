-- require "nvchad.mappings"
local map = vim.keymap.set

map("n", "<leader>u?", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

-- global lsp mappings
map("n", "<leader>xl", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- picker
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "Find all files" }
)
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "live grep" })
map("n", "<leader>/", "<cmd>Telescope live_grep<CR>", { desc = "live grep", remap = true })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help  pages" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Find keymaps" })
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "Find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Find old files" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Find in current buffer" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git Commits" })
map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git Status" })

map("n", "gd", function()
  require("telescope.builtin").lsp_definitions { reuse_win = true }
end, { desc = "Goto Definition" })
map("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "References", nowait = true })
map("n", "gI", function()
  require("telescope.builtin").lsp_implementations { reuse_win = true }
end, { desc = "Goto Implementation" })
map("n", "gy", function()
  require("telescope.builtin").lsp_type_definitions { reuse_win = true }
end, { desc = "Goto T[y]pe Definition" })

-- themes
map("n", "<leader>ut", function()
  require("nvchad.themes").open()
end, { desc = "NvChad Themes" })

-- terminal
map({ "n", "t" }, "<C-//>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "Toggle terminal" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

-- add yours here

local set = vim.keymap.set
local opts = { noremap = true, silent = true }

set({ "n", "v" }, "H", "^", opts)
set({ "n", "v" }, "L", "$", opts)
--
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
