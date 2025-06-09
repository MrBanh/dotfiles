vim.g.mapleader = ' '
vim.opt.conceallevel = 1
vim.opt.clipboard = ''

-- Minimal number of lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- mouse mode, can be useful for resizing
vim.o.mouse = 'a'

-- indent went wrapped
vim.o.breakindent = true

-- save undo history
vim.o.undofile = true

-- case-insensitive search unless >=1 capital letters
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- display certain whitespace characters in the editor
vim.o.list = false
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show which line your cursor is on
vim.o.cursorline = true

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Only show 1 statusline, and it corresponds with current buffer
vim.o.laststatus = 3

vim.g.have_nerd_font = true

-- wezterm won't let vim read from clipboard
local function paste()
  return {
    vim.fn.split(vim.fn.getreg '', '\n'),
    vim.fn.getregtype '',
  }
end
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy '+',
    ['*'] = require('vim.ui.clipboard.osc52').copy '*',
  },
  paste = {
    ['+'] = paste,
    ['*'] = paste,
  },
}

-- shada file
vim.opt.exrc = true
vim.opt.secure = true
local workspace_path = vim.fn.getcwd()
local cache_dir = vim.fn.stdpath 'data'
local unique_id = vim.fn.fnamemodify(workspace_path, ':t') .. '_' .. vim.fn.sha256(workspace_path):sub(1, 8) ---@type string
local shadafile = cache_dir .. '/myshada/' .. unique_id .. '.shada'
vim.opt.shadafile = shadafile
