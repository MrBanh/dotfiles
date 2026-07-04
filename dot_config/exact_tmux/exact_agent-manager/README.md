# agent-manager

A `sesh`-style `fzf` popup to jump between your running AI coding agents
(opencode, Claude Code) across every tmux session/window — with live status, a
color-coded activity feed, and desktop/tmux/terminal notifications.

```
prefix + e
```

## The popup

Agent picker on the left (input at the bottom, sesh-style); a preview of the
highlighted agent's **live window** — with a compact color-coded **activity
strip** on top — on the right:

```
┌───────────────────────────┬────────────────────────────────┐
│  idle    13m opencode ui:0│   Activity                     │
│  working  3s claude  db:2 │     14:22:30  Bash     npm test │
│▸ input    2m claude  api:1│     14:22:24  Read     app.ts   │
│  > (type to filter)       │   ── Window (live capture) ──   │
│  ^e attach  ^s resume …   │     …                           │
└───────────────────────────┴────────────────────────────────┘
```

- The **list** (left) puts agents that **need you** (waiting for input/permission,
  or errored) nearest the input box — right under the cursor — then orders the rest
  by most-recent activity. The second column is **time in the current state** (`3s`
  working, `13m` idle …), a status stopwatch that resets on each transition. Type to
  fuzzy-filter.
- The **preview** (right) is the highlighted agent's live window (a `capture-pane`,
  like sesh), with a color-coded **activity strip** on top — recent tool calls as
  `time  tool  target` (e.g. `Bash  npm test`), newest first, tool names mapped to
  stable colors. It follows your selection automatically.
- `enter` **views** the agent's window full-screen in a popup (see Smart jump).

### Keys (all customizable — see Options)

| Key                 | Action                                                                 |
| ------------------- | ---------------------------------------------------------------------- |
| `prefix + e`        | Open the picker — and from inside a viewed agent, close the view and exit |
| `prefix + BSpace`   | From inside a viewed agent, go **back** to the picker (override: `@agent_manager_back_key`) |
| `enter`             | **View** the agent right here in the popup (smart jump — see below)     |
| `ctrl-s`            | **Resume** the previously viewed agent                                  |
| `ctrl-e`            | **Jump** your real client to the agent and close the popup             |
| `ctrl-x`            | Kill the agent's window                                                |
| `ctrl-r`            | Refresh the list                                                        |
| type to filter      | fzf fuzzy search over status / agent / session / path                  |

### Smart jump

Inspired by
[craftzdog/tmux-claude-session-manager](https://github.com/craftzdog/tmux-claude-session-manager):

- `enter` **views** the agent inside the popup. It attaches a *grouped* session,
  so it does **not** yank the agent's window away from other clients already
  attached to that session.
- `prefix + e` from inside a viewed agent **closes the view and exits**.
- `prefix + BSpace` from inside a viewed agent **goes back to the picker**, so you
  can hop straight to another agent. (While the fzf picker itself is up, fzf owns
  the keyboard — use `Esc` / `Ctrl-C` to close it.)
- `ctrl-s` **resumes** the agent you last viewed — straight back into it without
  picking.
- `ctrl-e` **commits**: moves your real (outer) client to the agent's window and
  closes the popup.

## How it works

- **Listing is process-based** — it scans each pane's process subtree and matches
  the real agent binary, so an agent appears the instant it launches (no hook or
  interaction). The pane's foreground command is often a wrapper (`dvx opencode`
  runs as `python3.12`); the scan finds the `opencode` child.
- **Status + activity + notifications are push-based, not scraped** — small
  integrations make each agent write its state to the pane option `@agent_state`,
  append events to a per-pane activity log, and fire notifications on the key
  transitions. States: `working` · `idle` · `input` (waiting on you) · `error`
  (`—` before an agent reports).

## Install

1. Add one line to your tmux config to load the binding:

   ```tmux
   run-shell "~/.config/tmux/agent-manager/agent-manager.tmux"
   ```

2. Wire up live status **once** (a deliberate manual step — it edits your agent
   configs, so it is not run on every tmux load):

   ```sh
   ~/.config/tmux/agent-manager/bin/agent-manager install
   ```

   - **opencode** — symlinks the plugin into `~/.config/opencode/plugins/`.
     Restart opencode instances to load it.
   - **claude** — merges hooks into `~/.claude/settings.json` (idempotent,
     preserves your other hooks, refuses to touch invalid JSON).

The popup works without step 2 — you just won't get status/activity/notifications
(agents show `—`). Listing / viewing / jumping / killing all work from process
detection alone.

> **If `~/.claude/settings.json` is managed by other tooling** (e.g. a managed or
> corporate dotfiles setup), that tooling may rewrite the file and strip these
> hooks. Just re-run `agent-manager install`.

## Notifications

Off by default. Fired when an agent **finishes**, **needs your input**, or
**errors** — and skipped for an agent you're actively looking at.

```tmux
set -g @agent_manager_notify       'system'   # off | tmux | terminal | system
set -g @agent_manager_notify_sound 'Glass'    # off | macOS sound name | file path
```

- `tmux` — a tmux status-line message
- `terminal` — rings the bell on attached terminals
- `system` — macOS `osascript` / Linux `notify-send`
- Sound is independent of the channel; `off` (or unset) plays nothing. When
  `@agent_manager_notify` is `off`, nothing fires and no sound plays.

## Options

Set before the `run-shell` line (defaults shown):

| Option                          | Default   | Meaning                                        |
| ------------------------------- | --------- | ---------------------------------------------- |
| `@agent_manager_key`            | `e`       | prefix key to open the manager / exit a view   |
| `@agent_manager_back_key`       | `BSpace`  | prefix key: from a view, go back to the picker |
| `@agent_manager_jump_key`       | `ctrl-e`  | (in picker) jump your client to the agent      |
| `@agent_manager_resume_key`     | `ctrl-s`  | (in picker) resume the previously viewed agent |
| `@agent_manager_kill_key`       | `ctrl-x`  | (in picker) kill the agent's window            |
| `@agent_manager_refresh_key`    | `ctrl-r`  | (in picker) refresh the list                   |
| `@agent_manager_width`          | `90%`     | popup width                                    |
| `@agent_manager_height`         | `90%`     | popup height                                   |
| `@agent_manager_notify`         | `off`     | `off` \| `tmux` \| `terminal` \| `system`      |
| `@agent_manager_notify_sound`   | `off`     | `off` \| macOS sound name \| sound file path   |

`jump`/`resume`/`kill`/`refresh` are **fzf** key names (e.g. `ctrl-e`, `alt-k`);
`key`/`back_key` are **tmux** prefix key names (e.g. `e`, `BSpace`, `o`).

## Notes

- No third-party libraries — just tmux, `fzf`, `awk`/`ps`/`sed`, and (for the
  Claude settings merge only) system `python3` standard library.
- Kept outside `plugins/` so TPM's `clean` never removes it.
