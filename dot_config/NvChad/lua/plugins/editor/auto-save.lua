-- I do not want to save when I'm in visual mode because I'm usually moving
-- stuff from one place to another, or deleting it
-- https://github.com/okuuva/auto-save.nvim/issues/67#issuecomment-2597631756
local visual_event_group = vim.api.nvim_create_augroup("visual_event", { clear = true })

vim.api.nvim_create_autocmd("ModeChanged", {
  group = visual_event_group,
  pattern = { "*:[vV\x16]*" },
  callback = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "VisualEnter" })
    -- print("VisualEnter")
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  group = visual_event_group,
  pattern = { "[vV\x16]*:*" },
  callback = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "VisualLeave" })
    -- print("VisualLeave")
  end,
})

return {
  "okuuva/auto-save.nvim",
  version = "*",
  cmd = "ASToggle", -- optional for lazy loading on command
  event = { "InsertLeave" }, -- optional for lazy loading on trigger events
  opts = {
    condition = function(buf)
      local filetype = vim.fn.getbufvar(buf, "&filetype")
      -- don't save for 'harpoon'
      if
        vim.list_contains({
          -- from plugins
          "OverseerForm",
          "Trouble",
          "grug-far",
          "harpoon",
          "lazy",
          "lspinfo",
          "mason",
          "octo",
          "trouble",

          -- file types
          "sql",

          -- specific files
          "wezterm.lua",
        }, filetype)
      then
        return false
      end

      return true
    end,

    callbacks = {
      before_saving = function()
        -- save global autoformat status
        vim.g.OLD_AUTOFORMAT = vim.g.autoformat_enabled
        vim.g.autoformat_enabled = false
        vim.g.OLD_AUTOFORMAT_BUFFERS = {}
        -- disable all manually enabled buffers
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.b[bufnr].autoformat_enabled then
            table.insert(vim.g.OLD_BUFFER_AUTOFORMATS, bufnr)
            vim.b[bufnr].autoformat_enabled = false
          end
        end
      end,
      after_saving = function()
        -- restore global autoformat status
        vim.g.autoformat_enabled = vim.g.OLD_AUTOFORMAT
        -- reenable all manually enabled buffers
        for _, bufnr in ipairs(vim.g.OLD_AUTOFORMAT_BUFFERS or {}) do
          vim.b[bufnr].autoformat_enabled = true
        end
      end,
    },

    -- delay after which a pending save is executed (default 1000)
    debounce_delay = 2000,
  },
}
