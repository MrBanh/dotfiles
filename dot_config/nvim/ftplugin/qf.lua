local del_qf_item = function()
  local items = vim.fn.getqflist()
  local line = vim.fn.line(".")
  table.remove(items, line)
  vim.fn.setqflist(items, "r")
  vim.api.nvim_win_set_cursor(0, { line, 0 })
end

vim.keymap.set("n", "dd", del_qf_item, { silent = true, buffer = true, desc = "Remove entry from QF" })
vim.keymap.set("v", "D", del_qf_item, { silent = true, buffer = true, desc = "Remove entry from QF" })

-- force quickfix to open at the bottom all the time, even if there's a vert split
vim.cmd.wincmd("J")

-- set the height of quickfix
local height = math.floor(vim.o.lines * 0.3)
vim.cmd(height .. "wincmd_")
