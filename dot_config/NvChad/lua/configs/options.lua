-- Disable auto comments on new line
vim.cmd "autocmd BufNewFile,BufRead,BufEnter,FileType * set formatoptions-=cro"
vim.cmd "autocmd BufNewFile,BufRead,BufEnter,FileType * setlocal formatoptions-=cro"

-- Line numbers
vim.cmd "autocmd InsertEnter * set nu nornu"
vim.cmd "autocmd InsertLeave * set nu rnu"

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.conceallevel = 1

vim.opt.clipboard = ""

-- wezterm won't let vim read from clipboard
local function paste()
  return {
    vim.fn.split(vim.fn.getreg "", "\n"),
    vim.fn.getregtype "",
  }
end
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy "+",
    ["*"] = require("vim.ui.clipboard.osc52").copy "*",
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}

-- shada file
vim.opt.exrc = true
vim.opt.secure = true
local workspace_path = vim.fn.getcwd()
local cache_dir = vim.fn.stdpath "data"
local unique_id = vim.fn.fnamemodify(workspace_path, ":t") .. "_" .. vim.fn.sha256(workspace_path):sub(1, 8) ---@type string
local shadafile = cache_dir .. "/myshada/" .. unique_id .. ".shada"
vim.opt.shadafile = shadafile
