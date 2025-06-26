local set = vim.keymap.set
local opts = { noremap = true, silent = true }

set('n', '<Esc>', '<cmd>nohlsearch<CR>')

set({ 'n', 'v' }, 'H', '^', opts)
set({ 'n', 'v' }, 'L', '$', opts)

vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

-- Paste without overwriting
set('v', 'p', 'P', opts)

-- Do not overwrite when using change command
set('n', 'c', [["_c]], opts)
set('v', 'c', [["_c]], opts)

-- Better escape
set('i', 'jk', '<Esc>', opts)

-- better indent handling
set('v', '<', '<gv', opts)
set('v', '>', '>gv', opts)

-- move text up and down
set('v', 'J', ':m .+1<CR>==', opts)
set('v', 'K', ':m .-2<CR>==', opts)
set('x', 'J', ":move '>+1<CR>gv-gv", opts)
set('x', 'K', ":move '<-2<CR>gv-gv", opts)

-- regex helpers
set('c', [[\\*]], [[\(.*\)]])
set('c', [[\\-]], [[\(.\{-}\)]])

-- Search current word under cursor in current buffer
set({ 'n', 'x' }, '<leader>/', function()
  local word = vim.fn.expand '<cword>'
  vim.cmd('/' .. word)
end, {
  desc = 'Search current word in buffer',
})

-- Yank to clipboard
set({ 'n', 'v' }, '<leader>Y', [["+y]], vim.tbl_extend('force', opts, { desc = '[Y]ank selected to clipboard' }))

-- paste from system clipboard
set({ 'n', 'v' }, '<leader>P', [["+p]], vim.tbl_extend('force', opts, { desc = '[P]aste from clipboard' }))

-- source lua file
set('n', '<C-w>%', '<Cmd>source %<CR>')

-- exit terminal mode while in terminal
set('t', '<C-x>', '<C-\\><C-N>', { desc = 'terminal escape terminal mode' })

vim.keymap.set('n', '<leader>xl', vim.diagnostic.setloclist, { desc = 'Quickfix List' })

-- Browser search bar (see autocmds.lua)
vim.keymap.set('n', '<leader>sO', ':SearchInBrowser<CR>', {
  desc = 'Search in browser',
})
