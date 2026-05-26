local M = {}

--- Return the visually selected text as a list of lines.
--- Works while still in visual mode AND after it has been exited (e.g. when
--- called from a `<Cmd>`-style keymap, which lazy.nvim uses), by falling back
--- to the `'<` / `'>` marks plus `visualmode()` in that case.
---@return string[]
function M.get_visual_selection_text()
  local mode = vim.fn.mode()
  local pos1, pos2

  if mode == "v" or mode == "V" or mode == "\22" then
    pos1 = vim.fn.getpos("v")
    pos2 = vim.fn.getpos(".")
  else
    -- Not currently in visual mode — use the last-visual marks instead.
    mode = vim.fn.visualmode()
    if mode == "" then
      return {}
    end
    pos1 = vim.fn.getpos("'<")
    pos2 = vim.fn.getpos("'>")
  end

  return vim.fn.getregion(pos1, pos2, { type = mode })
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

--- Relaunch nvim inside the current tmux pane, optionally in a different
--- directory and with persistence.nvim session restore. The current pane's
--- nvim is killed and replaced with a fresh interactive shell that auto-runs
--- `nvim`; when that nvim exits the shell remains in `path`.
---
--- No-op (with a warning) when not running inside tmux.
---
---@param path string|nil Target directory. Defaults to the current working directory.
---@param opts? { restore_session?: boolean }
---@return boolean started true when the tmux respawn was dispatched
function M.tmux_relaunch_nvim(path, opts)
  opts = opts or {}

  if not vim.env.TMUX then
    vim.notify("Not in tmux; cannot relaunch nvim", vim.log.levels.WARN)
    return false
  end

  local target = path or vim.fn.getcwd()
  target = vim.fn.fnamemodify(target, ":p"):gsub("/$", "")

  local shell = vim.env.SHELL or "/bin/zsh"
  local nvim_cmd = "nvim"
  if opts.restore_session then
    nvim_cmd = nvim_cmd .. " -c " .. vim.fn.shellescape("silent! lua require('persistence').load()")
  end

  local cmd = string.format(
    "%s -i -c %s",
    vim.fn.shellescape(shell),
    vim.fn.shellescape(string.format("%s; exec %s -i", nvim_cmd, shell))
  )

  vim.fn.jobstart({
    "tmux",
    "respawn-pane",
    "-k",
    "-c",
    target,
    cmd,
  }, { detach = true })

  return true
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
