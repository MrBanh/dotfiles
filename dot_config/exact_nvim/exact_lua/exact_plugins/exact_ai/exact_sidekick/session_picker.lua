-- ---------------------------------------------------------------------------
-- snacks.nvim picker that lists ALL sidekick.nvim CLI sessions (across every
-- worktree, since sidekick discovers tmux sessions globally) and lets you
-- delete the ones you select.
--
--   * <CR> / dd / <C-x>  -> delete the selected session(s), then refresh
--
-- "Deleting" a session tears down its tmux target (the mux backend in use).
-- Rows are rendered with sidekick's own formatter (`cli.ui.select.format`) so
-- tool / backend / cwd all show, making cross-worktree sessions easy to tell
-- apart. The picker stays open after a delete so you can prune several at once.
-- ---------------------------------------------------------------------------

local M = {}

--- Tear down the tmux session/pane backing a sidekick CLI state.
---@param state table sidekick.cli.State
---@return boolean ok, string? err
local function kill_session(state)
  local session = state and state.session
  if not session then
    return false, "no session to delete"
  end

  -- A session may be a raw tmux session, or an nvim-terminal wrapper whose
  -- parent is tmux; in the latter case the mux fields live on `mux_*`.
  local backend = session.mux_backend or session.backend
  if backend ~= "tmux" then
    return false, ("cannot delete a %s session"):format(backend or "unknown")
  end

  local cmd
  if session.tmux_pane_id then
    -- Most precise: kill just this pane. For a dedicated sidekick session
    -- (single pane) this also ends the session.
    cmd = { "tmux", "kill-pane", "-t", session.tmux_pane_id }
  elseif session.mux_session then
    cmd = { "tmux", "kill-session", "-t", session.mux_session }
  else
    return false, "no tmux target found for session"
  end

  local out = vim.system(cmd, { text = true }):wait()
  if out.code ~= 0 then
    return false, vim.trim(out.stderr ~= "" and out.stderr or "tmux exited with an error")
  end
  return true
end

--- Open a picker of all sidekick sessions; delete the selected one(s).
function M.open()
  local ok_snacks = pcall(require, "snacks")
  if not ok_snacks or not (Snacks and Snacks.picker) then
    return vim.notify("snacks.picker is required for this picker", vim.log.levels.ERROR)
  end

  local State = require("sidekick.cli.state")
  local Select = require("sidekick.cli.ui.select")
  local Util = require("sidekick.util")

  local function finder()
    local items = {}
    -- No filter -> every discovered session (all tools, all worktrees).
    for _, state in ipairs(State.get()) do
      if state.session then -- skip installed-but-not-running tool entries
        items[#items + 1] = {
          state = state,
          idx = #items + 1,
          text = table.concat({
            state.tool and state.tool.name or "",
            state.session.cwd or "",
            state.session.mux_session or "",
          }, " "),
        }
      end
    end
    return items
  end

  local function delete(picker)
    local killed, failures = 0, {}
    for _, item in ipairs(picker:selected({ fallback = true })) do
      local ok, err = kill_session(item.state)
      if ok then
        killed = killed + 1
      elseif err then
        failures[#failures + 1] = err
      end
    end
    if killed > 0 then
      Util.info(("Deleted %d sidekick session%s"):format(killed, killed == 1 and "" or "s"))
    end
    if #failures > 0 then
      Util.warn(table.concat(failures, "\n"))
    end
    picker:refresh()
    -- refresh() pauses the list to avoid flicker while (re)finding; snacks only
    -- skips that pause when the list overflows the window, so for a short
    -- session list the re-render is suppressed. Force it to redraw now.
    picker.list:unpause()
  end

  return Snacks.picker.pick({
    source = "sidekick_sessions",
    title = "Sidekick Sessions (delete)",
    finder = finder,
    format = function(item, picker)
      item.state.idx = item.idx
      return Select.format(item.state, picker)
    end,
    actions = {
      sidekick_kill = delete,
    },
    win = {
      input = {
        keys = {
          ["<cr>"] = { "sidekick_kill", mode = { "n", "i" }, desc = "Delete session" },
          ["<c-x>"] = { "sidekick_kill", mode = { "n", "i" }, desc = "Delete session" },
        },
      },
      list = {
        keys = {
          ["<cr>"] = "sidekick_kill",
          ["dd"] = { "sidekick_kill", desc = "Delete session" },
        },
      },
    },
  })
end

return M
