-- Disable auto comments on new line
vim.cmd "autocmd BufEnter * set formatoptions-=cro"
vim.cmd "autocmd BufEnter * setlocal formatoptions-=cro"

-- Line numbers
vim.cmd "autocmd InsertEnter * set nu nornu"
vim.cmd "autocmd InsertLeave * set nu rnu"

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.schedule(function() vim.opt.clipboard = "" end)
