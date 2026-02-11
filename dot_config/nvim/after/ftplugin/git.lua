local utils = require("utils")

vim.keymap.set("n", "<C-g>", function()
  local sha = utils.get_commit_sha()
  if sha then
    utils.open_commit_in_browser(sha)
  end
end, { silent = true, buffer = true, desc = "Open commit in browser" })
