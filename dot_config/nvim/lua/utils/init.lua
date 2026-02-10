local M = {}

function M.is_claudecode_diff(buf)
  local bufname = vim.api.nvim_buf_get_name(buf)
  if bufname:match("%(proposed%)") or bufname:match("%(NEW FILE %- proposed%)") or bufname:match("%(New%)") then
    return true
  end

  if
    vim.b[buf].claudecode_diff_tab_name
    or vim.b[buf].claudecode_diff_new_win
    or vim.b[buf].claudecode_diff_target_win
  then
    return true
  end

  local buftype = vim.fn.getbufvar(buf, "&buftype")
  if buftype == "acwrite" then
    return true
  end

  return false
end

---@return string|nil
function M.get_commit_sha()
  local line = vim.api.nvim_get_current_line()
  local sha = line:match("^commit (%x+)")
  if sha then
    return sha
  else
    vim.notify("Not on a commit line", vim.log.levels.WARN)
    return nil
  end
end

---@param commit string
function M.open_commit_in_browser(commit)
  local snacks = require("snacks")
  local cwd = snacks.git.get_root() or vim.fn.getcwd()
  local remote_url = vim.fn.system("git -C " .. vim.fn.shellescape(cwd) .. " remote get-url origin"):gsub("\n", "")

  if remote_url and remote_url ~= "" then
    ---@diagnostic disable-next-line: invisible
    local repo = snacks.gitbrowse.get_repo(remote_url)
    local url = snacks.gitbrowse.get_url(repo, { commit = commit }, { what = "commit" })
    snacks.notify("Opening URL: " .. url, { title = "Git Browse" })
    vim.ui.open(url)
  end
end

return M
