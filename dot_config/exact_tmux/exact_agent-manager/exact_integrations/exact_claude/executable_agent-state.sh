#!/bin/sh
# agent-manager claude integration.
#
# A Claude Code hook that, for the pane it runs in ($TMUX_PANE, set by tmux):
#   - records the live state in the pane option @agent_state
#   - appends the event to a per-pane activity log the popup shows
#   - fires a notification (via agent-manager) on Stop (done) / Notification
#     (needs input)
#
# State is passed as $1 by the settings.json wiring (install.py):
#   SessionStart/Stop -> idle, UserPromptSubmit/PreToolUse -> working,
#   Notification -> waiting. The full hook JSON arrives on stdin; we read it to
#   pick out the tool name (for activity) and the event name (to decide whether
#   to notify). Always exits 0 so it never blocks a tool call.

input="$(cat 2>/dev/null)"
[ -n "${TMUX_PANE:-}" ] || exit 0
[ -n "${TMUX:-}" ] || exit 0

state="${1:-idle}"
# Bump @agent_state_ts only when the state actually changes, so the picker's timer
# reads time-in-current-state (how long working / idle / waiting), not time-per-event.
prev="$(tmux show -p -t "$TMUX_PANE" -qv @agent_state 2>/dev/null)"
tmux set-option -p -t "$TMUX_PANE" @agent_state "$state" 2>/dev/null || true
if [ "$state" != "$prev" ]; then
  tmux set-option -p -t "$TMUX_PANE" @agent_state_ts "$(date +%s)" 2>/dev/null || true
fi

# --- activity (pipe-delimited "HH:MM:SS|tool|detail"; the picker colorizes it) ---
tool="$(printf '%s' "$input" | sed -n 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"
event="$(printf '%s' "$input" | sed -n 's/.*"hook_event_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"

# The argument that mattered — first present of command/file_path/pattern/url/description.
detail=""
for k in command file_path pattern url description; do
  v="$(printf '%s' "$input" | sed -n "s/.*\"$k\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" | head -1)"
  if [ -n "$v" ]; then
    [ "$k" = file_path ] && v="${v##*/}"
    detail="$v"
    break
  fi
done
detail="$(printf '%s' "$detail" | tr '\r\n|' '   ' | cut -c1-48)"

# Tool column: the tool name for tool calls, plus a couple of milestones. Skip the
# noisy per-turn prompt/idle transitions — status already shows in the list column.
field=""
if [ -n "$tool" ]; then field="$tool"
elif [ "$event" = SessionStart ]; then field="started"
elif [ "$state" = waiting ]; then field="waiting"; [ -z "$detail" ] && detail="needs your input"
fi

if [ -n "$field" ]; then
  dir="${TMPDIR:-/tmp}/agent-manager/activity"
  mkdir -p "$dir" 2>/dev/null
  printf '%s|%s|%s\n' "$(date +%H:%M:%S)" "$field" "$detail" >> "$dir/$TMUX_PANE.log" 2>/dev/null || true
fi

# --- notification (only on turn-finished / needs-input, never on start) ---
bin="$(tmux show -gv @agent_manager_bin 2>/dev/null)"
if [ -n "$bin" ]; then
  case "$event" in
    Stop)         "$bin" notify "$TMUX_PANE" claude idle 2>/dev/null || true ;;
    Notification) "$bin" notify "$TMUX_PANE" claude waiting 2>/dev/null || true ;;
  esac
fi

exit 0
