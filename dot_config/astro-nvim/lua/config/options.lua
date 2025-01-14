-- Disable auto comments on new line
vim.cmd "autocmd BufNewFile,BufRead,BufEnter,FileType * set formatoptions-=cro"
vim.cmd "autocmd BufNewFile,BufRead,BufEnter,FileType * setlocal formatoptions-=cro"

-- Line numbers
vim.cmd "autocmd InsertEnter * set nu nornu"
vim.cmd "autocmd InsertLeave * set nu rnu"

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
vim.opt.conceallevel = 1

vim.schedule(function() vim.opt.clipboard = "" end)
