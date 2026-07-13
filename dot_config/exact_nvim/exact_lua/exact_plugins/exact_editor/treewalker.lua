-- Run a Treewalker command; if it errors or the cursor doesn't move
-- (e.g. we're at the edge of the tree), fall back to the default key.
local function walk(cmd, fallback)
  return function()
    local before = vim.api.nvim_win_get_cursor(0)
    local ok = pcall(vim.api.nvim_command, "Treewalker " .. cmd)
    if ok then
      local after = vim.api.nvim_win_get_cursor(0)
      if before[1] ~= after[1] or before[2] ~= after[2] then
        return
      end
    end
    local keys = vim.api.nvim_replace_termcodes(fallback, true, false, true)
    vim.api.nvim_feedkeys(keys, "n", false)
  end
end

return {
  "aaronik/treewalker.nvim",
  opts = {
    notifications = false,
  },
  keys = {
    { "<Up>", walk("Up", "<Up>"), mode = { "n", "v" }, desc = "Treewalker Up", silent = true },
    { "<Down>", walk("Down", "<Down>"), mode = { "n", "v" }, desc = "Treewalker Down", silent = true },
    { "<Left>", walk("Left", "<Left>"), mode = { "n", "v" }, desc = "Treewalker Left", silent = true },
    { "<Right>", walk("Right", "<Right>"), mode = { "n", "v" }, desc = "Treewalker Right", silent = true },
    { "<S-Up>", walk("SwapUp", "<S-Up>"), mode = { "n" }, desc = "Treewalker Swap Up", silent = true },
    { "<S-Down>", walk("SwapDown", "<S-Down>"), mode = { "n" }, desc = "Treewalker Swap Down", silent = true },
    { "<S-Left>", walk("SwapLeft", "<S-Left>"), mode = { "n" }, desc = "Treewalker Swap Left", silent = true },
    { "<S-Right>", walk("SwapRight", "<S-Right>"), mode = { "n" }, desc = "Treewalker Swap Right", silent = true },
  },
}
