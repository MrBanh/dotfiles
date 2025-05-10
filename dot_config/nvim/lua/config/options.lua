-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable auto comments on new line
vim.cmd("autocmd BufNewFile,BufRead,BufEnter,FileType * set formatoptions-=cro")
vim.cmd("autocmd BufNewFile,BufRead,BufEnter,FileType * setlocal formatoptions-=cro")

-- Line numbers
vim.cmd("autocmd InsertEnter * set nu nornu")
vim.cmd("autocmd InsertLeave * set nu rnu")

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.conceallevel = 1

vim.opt.clipboard = ""

-- wezterm won't let vim read from clipboard
local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}

-- use ai suggestion in cmp, false shows inline suggestion
vim.g.ai_cmp = false

-- Fixes: Snacks picker not opening files with <CR> in insert mode with bullets.vim
--- https://github.com/folke/snacks.nvim/issues/812
vim.g.bullets_enable_in_empty_buffers = 0

-- blink, requires NeoVim >= 0.11
vim.o.winborder = "rounded"
