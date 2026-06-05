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

--- Build a shell command string that launches nvim and then `exec`s an
--- interactive shell once nvim exits. Useful for embedding into tmux session
--- / pane commands where the surrounding shell should outlive nvim.
---
--- When `opts.restore_session` is true, the launched nvim runs
--- persistence.nvim's `load()` on startup so the previous session for the
--- current cwd is restored.
---
---@param opts? { restore_session?: boolean }
---@return string cmd Shell command suitable for `sh -c <cmd>`.
function M.relaunch_nvim_cmd(opts)
  opts = opts or {}
  local shell = vim.env.SHELL or "/bin/zsh"
  local nvim_cmd = "nvim"
  if opts.restore_session then
    nvim_cmd = nvim_cmd .. " -c " .. vim.fn.shellescape("silent! lua require('persistence').load()")
  end
  return string.format(
    "%s -i -c %s",
    vim.fn.shellescape(shell),
    vim.fn.shellescape(string.format("%s; exec %s -i", nvim_cmd, vim.fn.shellescape(shell)))
  )
end

--- Create a detached tmux session named `name` and switch the current tmux
--- client to it. If `opts.cmd` is provided it runs as the session's initial
--- process in `opts.cwd`. If a session with that exact name already exists,
--- the create step is skipped and the client just switches to it.
---
--- The session the client was on before is left untouched, so anything
--- running there keeps running and is reachable via normal tmux session
--- switching.
---
--- No-op (with a warning) when not running inside tmux.
---
---@param name string Session name; characters reserved by tmux (`:` and `.`)
---       and whitespace are sanitized to `_`. Other punctuation like `|` and
---       `/` is left as-is.
---@param opts? { cwd?: string, cmd?: string }
---@return boolean started true when the tmux command was dispatched
function M.new_tmux_session(name, opts)
  opts = opts or {}

  if not vim.env.TMUX then
    vim.notify("Not in tmux; cannot create session", vim.log.levels.WARN)
    return false
  end

  -- tmux disallows `:` and `.` in session names (they're target separators),
  -- and whitespace is asking for trouble.
  local session_name = (name:gsub("[:%.%s]", "_"))

  -- Reuse an existing session with this exact name if one is already alive.
  vim.fn.system({ "tmux", "has-session", "-t", "=" .. session_name })
  if vim.v.shell_error ~= 0 then
    local args = { "tmux", "new-session", "-d", "-s", session_name }
    if opts.cwd and opts.cwd ~= "" then
      table.insert(args, "-c")
      table.insert(args, opts.cwd)
    end
    if opts.cmd and opts.cmd ~= "" then
      table.insert(args, opts.cmd)
    end
    local out = vim.fn.system(args)
    if vim.v.shell_error ~= 0 then
      vim.notify("tmux new-session failed: " .. out, vim.log.levels.ERROR)
      return false
    end
  end

  vim.fn.jobstart({ "tmux", "switch-client", "-t", "=" .. session_name }, { detach = true })
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
