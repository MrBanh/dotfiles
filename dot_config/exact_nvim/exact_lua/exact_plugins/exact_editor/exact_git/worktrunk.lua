local utils = require("user.utils")
local relaunch_nvim_cmd = utils.relaunch_nvim_cmd
local new_tmux_session = utils.new_tmux_session

-- Max display width for the branch column before truncating with an ellipsis.
local MAX_BRANCH_WIDTH = 60

-- Shared widths captured by finder + format for column alignment.
local widths = { branch = 0, head = 0, main = 0, commit = 0 }

local function fmt_head(wt)
  local d = wt.working_tree and wt.working_tree.diff
  if not d then
    return ""
  end
  local parts = {}
  if (d.added or 0) > 0 then
    parts[#parts + 1] = "+" .. d.added
  end
  if (d.deleted or 0) > 0 then
    parts[#parts + 1] = "-" .. d.deleted
  end
  return table.concat(parts, " ")
end

local function fmt_main(wt)
  if not wt.main then
    return ""
  end
  local parts = {}
  if (wt.main.ahead or 0) > 0 then
    parts[#parts + 1] = "↑" .. wt.main.ahead
  end
  if (wt.main.behind or 0) > 0 then
    parts[#parts + 1] = "↓" .. wt.main.behind
  end
  return table.concat(parts, " ")
end

local function wt_finder()
  local cwd = vim.fn.getcwd()
  local out = vim.fn.systemlist({ "wt", "-C", cwd, "list", "--branches", "--format", "json" })
  if vim.v.shell_error ~= 0 then
    vim.notify("wt list failed: " .. table.concat(out, "\n"), vim.log.levels.ERROR)
    return {}
  end
  local ok, data = pcall(vim.json.decode, table.concat(out, "\n"))
  if not ok or type(data) ~= "table" then
    return {}
  end

  -- Reset widths per refresh.
  widths.branch, widths.head, widths.main, widths.commit = 0, 0, 0, 0

  local items = {}
  for _, wt in ipairs(data) do
    local branch = wt.branch or "(detached)"
    local marker = wt.is_current and "● " or (wt.kind == "branch" and "○ " or "  ")
    -- Truncate the visible label but keep `branch` intact for `wt switch`.
    local label = marker .. Snacks.picker.util.truncate(branch, MAX_BRANCH_WIDTH - vim.fn.strdisplaywidth(marker))
    local head = fmt_head(wt)
    local main = fmt_main(wt)
    local commit = (wt.commit and wt.commit.short_sha) or ""

    widths.branch = math.max(widths.branch, vim.fn.strdisplaywidth(label))
    widths.head = math.max(widths.head, vim.fn.strdisplaywidth(head))
    widths.main = math.max(widths.main, vim.fn.strdisplaywidth(main))
    widths.commit = math.max(widths.commit, vim.fn.strdisplaywidth(commit))

    items[#items + 1] = {
      text = label,
      branch = branch,
      file = wt.path,
      cwd = wt.path,
      data = wt,
      _head = head,
      _main = main,
      _commit = commit,
    }
  end
  return items
end

local function wt_format(item)
  local wt = item.data
  local ret = {}

  ret[#ret + 1] =
    { Snacks.picker.util.align(item.text, widths.branch), wt.is_current and "SnacksPickerDirectory" or "" }
  ret[#ret + 1] = { "  " }

  -- HEAD± column: split into +N (green) -N (red), padded together.
  local head = item._head
  if head ~= "" then
    local added, deleted = head:match("^(%+%d+)%s*(.*)$")
    if added then
      ret[#ret + 1] = { added, "diffAdded" }
      if deleted ~= "" then
        ret[#ret + 1] = { " " }
        ret[#ret + 1] = { deleted, "diffRemoved" }
      end
    else
      ret[#ret + 1] = { head, "diffRemoved" }
    end
    local pad_n = widths.head - vim.fn.strdisplaywidth(head)
    if pad_n > 0 then
      ret[#ret + 1] = { string.rep(" ", pad_n) }
    end
  else
    ret[#ret + 1] = { string.rep(" ", widths.head) }
  end
  ret[#ret + 1] = { "  " }

  -- main↕ column: ↑N green ↓N red, padded together.
  local main = item._main
  if main ~= "" then
    local ahead, behind = main:match("^(↑%d+)%s*(.*)$")
    if ahead then
      ret[#ret + 1] = { ahead, "diffAdded" }
      if behind ~= "" then
        ret[#ret + 1] = { " " }
        ret[#ret + 1] = { behind, "diffRemoved" }
      end
    else
      ret[#ret + 1] = { main, "diffRemoved" }
    end
    local pad_n = widths.main - vim.fn.strdisplaywidth(main)
    if pad_n > 0 then
      ret[#ret + 1] = { string.rep(" ", pad_n) }
    end
  else
    ret[#ret + 1] = { string.rep(" ", widths.main) }
  end
  ret[#ret + 1] = { "  " }

  ret[#ret + 1] = { Snacks.picker.util.align(item._commit, widths.commit), "SnacksPickerGitCommit" }
  return ret
end

local function wt_preview(ctx)
  local item = ctx.item
  if not item or not item.cwd then
    return false
  end
  local lines = vim.fn.systemlist({
    "git",
    "-C",
    item.cwd,
    "log",
    "--oneline",
    "--decorate",
    "--color=never",
    "-n",
    "20",
  })
  if vim.v.shell_error ~= 0 then
    lines = { "git log failed:", unpack(lines) }
  end
  ctx.preview:reset()
  ctx.preview:set_lines(lines)
  ctx.preview:highlight({ ft = "git" })
  return true
end

--- Run `wt switch` (optionally with --create) and relaunch nvim in the
--- resulting worktree.
---@param branch string
---@param opts? { create?: boolean }
local function switch_and_relaunch(branch, opts)
  opts = opts or {}
  local args = { "wt", "switch", "--format", "json", "--no-cd", "-y" }
  if opts.create then
    -- `--base=@` explicitly bases the new branch on current HEAD.
    args[#args + 1] = "--create"
    args[#args + 1] = "--base=@"
  end
  args[#args + 1] = branch

  local switch_out = vim.fn.systemlist(args)
  if vim.v.shell_error ~= 0 then
    vim.notify("wt switch failed: " .. table.concat(switch_out, "\n"), vim.log.levels.ERROR)
    return
  end

  -- `wt switch --format json` may emit extra non-JSON status lines; find the
  -- JSON object line.
  local switch_data
  for _, line in ipairs(switch_out) do
    local ok, decoded = pcall(vim.json.decode, line)
    if ok and type(decoded) == "table" and decoded.path then
      switch_data = decoded
      break
    end
  end
  if not switch_data then
    vim.notify("wt switch returned no path:\n" .. table.concat(switch_out, "\n"), vim.log.levels.WARN)
    return
  end

  local path = vim.fn.fnamemodify(switch_data.path, ":p"):gsub("/$", "")
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p"):gsub("/$", "")
  if path == cwd then
    vim.notify("Already in worktree: " .. path)
    return
  end

  -- The primary worktree (main/master) gets a bare session name; any other
  -- branch lives in a `wt|<name>` session so they're easy to spot in tmux.
  local wt_name = vim.fn.fnamemodify(path, ":t")
  local session_name = (branch == "main" or branch == "master") and wt_name or ("wt|" .. wt_name)
  local started = new_tmux_session(session_name, {
    cwd = path,
    cmd = relaunch_nvim_cmd({ restore_session = true }),
  })
  if not started then
    vim.cmd.tcd(path)
    vim.notify("tcd → " .. path)
  end
end

local function wt_confirm(picker, item)
  picker:close()
  if not item or not item.branch then
    return
  end

  -- Selecting the current worktree means "branch off from here": prompt for
  -- a new branch name and create a worktree from current HEAD.
  if item.data and item.data.is_current then
    vim.ui.input({ prompt = "New branch from HEAD: " }, function(name)
      if not name or name == "" then
        return
      end
      switch_and_relaunch(vim.trim(name), { create = true })
    end)
    vim.schedule(function()
      vim.cmd("startinsert")
    end)
    return
  end

  switch_and_relaunch(item.branch)
end

return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>gw",
      function()
        Snacks.picker.pick({
          source = "wt",
          title = "Worktrees",
          finder = wt_finder,
          format = wt_format,
          preview = wt_preview,
          confirm = wt_confirm,
        })
      end,
      desc = "Worktrees (wt)",
    },
  },
}
