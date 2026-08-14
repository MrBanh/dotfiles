-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Disable auto comments on new line
autocmd({ "BufNewFile", "BufRead", "BufEnter", "FileType" }, {
  pattern = "*",
  command = "set formatoptions-=cro",
})
autocmd({ "BufNewFile", "BufRead", "BufEnter", "FileType" }, {
  pattern = "*",
  command = "setlocal formatoptions-=cro",
})

-- Line numbers
local no_line_numbers = {
  "snacks_dashboard",
}

local line_number_group = augroup("LineNumbers", { clear = true })

autocmd("InsertEnter", {
  group = line_number_group,
  pattern = "*",
  callback = function()
    if vim.tbl_contains(no_line_numbers, vim.bo.filetype) then
      return
    end
    vim.cmd("set nu nornu")
  end,
})

autocmd("InsertLeave", {
  group = line_number_group,
  pattern = "*",
  callback = function()
    if vim.tbl_contains(no_line_numbers, vim.bo.filetype) then
      return
    end
    vim.cmd("set nu rnu")
  end,
})

-- Define windows to close with 'q'
autocmd("FileType", {
  pattern = {
    "grug-far-history",
    "dap-float",
    "sagarename",
  },
  group = augroup("WinCloseOnQDefinition", { clear = true }),
  command = [[
            nnoremap <buffer><silent> q :close<CR>
            set nobuflisted
        ]],
})

-- Disable wrap for filetypes
autocmd("FileType", {
  pattern = { "markdown", "md" },
  callback = function()
    vim.opt_local.wrap = false
  end,
})

-- Move filetypes to far right window
autocmd("FileType", {
  pattern = { "help", "man" },
  callback = function()
    vim.cmd("wincmd L")
  end,
})

-- Add to which-key for filetypes, usually involves localleader
autocmd("User", {
  desc = "Add which key for Git Conflict",
  pattern = "GitConflictDetected",
  callback = function()
    vim.keymap.set("n", "<localleader>c", "<nop>", { buffer = true, desc = "Git Conflict" })
  end,
})

-- QMK / ZMK
local group = augroup("MyQMK", {})
autocmd("BufEnter", {
  desc = "Format simple keymap",
  group = group,
  pattern = "*/eyelash_corne.keymap", -- this is a pattern to match the filepath of whatever board you wish to target
  callback = function()
    require("qmk").setup({
      auto_format_pattern = "*/eyelash_corne.keymap",
      name = "LAYOUT_eyelash_corne",
      variant = "zmk",
      layout = {
        "_ x x x x x x _ _ x _ x x x x x x",
        "_ x x x x x x _ x x x x x x x x x",
        "_ x x x x x x x _ x _ x x x x x x",
        "_ _ _ _ x x x _ _ _ _ x x x _ _ _",
      },
    })
  end,
})

autocmd("BufEnter", {
  desc = "Format overlap keymap",
  group = group,
  pattern = "*/MOKETA.keymap",
  callback = function()
    require("qmk").setup({
      auto_format_pattern = "*/MOKETA.keymap",
      name = "MOKETA",
      variant = "zmk",
      layout = {
        "x x x x x x _ x x x x x x",
        "x x x x x x _ x x x x x x",
        "x x x x x x _ x x x x x x",
        "_ _ _ x x x _ x x x _ _ _",
      },
    })
  end,
})

-- https://github.com/iamcco/markdown-preview.nvim/issues/547
autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.mdx",
  callback = function()
    vim.opt_local.filetype = "markdown"
  end,
})
