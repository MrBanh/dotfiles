#!/usr/bin/env bash
# Track a per-client "return session" so `prefix + Backspace` can jump back to
# where you were before you selected an agent in workmux (its sidebar or picker).
# Wired to the client-session-changed and client-attached hooks (see
# 03-hooks.conf), which pass the client's tty.
#
# Rule: only non-agent destinations are ever recorded as the return target. Ask
# workmux whether the newly selected pane is a tracked agent instead of relying
# on a `sidekick|` session name: workmux also tracks agents started in ordinary tmux
# sessions. While you switch between work sessions the target follows you, but
# the moment you land on an agent it FREEZES -- and stays frozen no matter how
# many agents you hop between (select agent -> select another -> another).
# That's what pins `prefix + Backspace` to the work session you started from.
#
# Origin is stored per client, keyed by the client's tty, in a global user
# option (@workmux_origin_<sanitized-tty>) holding a session id. We only ever use
# session IDs as tmux targets -- session NAMES (which here contain spaces and
# "|") are unreliable as -t targets.
#
# Args: $1 = client tty (#{client_tty})

tty="$1"
[ -n "$tty" ] || exit 0

# The session the client is now on. Query by tty (a stable id target) rather
# than trusting the hook's own #{session_id} resolution.
arrived_sid="$(tmux display-message -t "$tty" -p '#{session_id}' 2>/dev/null)"
[ -n "$arrived_sid" ] || exit 0

# Agent pane? workmux tracks both agents it creates in `sidekick|...` sessions
# and agents started in ordinary tmux sessions. If workmux cannot report its
# tracked panes, preserve the previous origin rather than overwriting it.
arrived_pane="$(tmux display-message -t "$tty" -p '#{pane_id}' 2>/dev/null)"
[ -n "$arrived_pane" ] || exit 0

workmux_status="$(workmux status --json 2>/dev/null)" || exit 0
if printf '%s\n' "$workmux_status" | jq -e --arg pane "$arrived_pane" \
  'any(.agents[]; .pane_id == $pane)' >/dev/null 2>&1; then
  exit 0
fi

# Landed on a work session -> that's home. Record it for this client.
key="@workmux_origin_$(printf '%s' "$tty" | tr -c 'A-Za-z0-9' '_')"
tmux set -g "$key" "$arrived_sid"
exit 0
