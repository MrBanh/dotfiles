local M = {}

function M.get_visual_selection_text()
  local _, srow, scol = unpack(vim.fn.getpos("v"))
  local _, erow, ecol = unpack(vim.fn.getpos("."))

  -- visual line mode
  if vim.fn.mode() == "V" then
    if srow > erow then
      return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
    else
      return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
    end
  end

  -- regular visual mode
  if vim.fn.mode() == "v" then
    if srow < erow or (srow == erow and scol <= ecol) then
      return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
    else
      return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
    end
  end

  -- visual block mode
  if vim.fn.mode() == "\22" then
    local lines = {}
    if srow > erow then
      srow, erow = erow, srow
    end
    if scol > ecol then
      scol, ecol = ecol, scol
    end
    for i = srow, erow do
      table.insert(
        lines,
        vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1]
      )
    end
    return lines
  end
end

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
