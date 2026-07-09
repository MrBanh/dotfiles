#!/usr/bin/env bash
# Track a per-client "return session" so `prefix + Backspace` can jump back to
# where you were before you started hopping through agents in the
# tmux-agent-sidebar. Wired to the client-session-changed and client-attached
# hooks (see 03-hooks.conf), which pass the client's tty.
#
# Rule: only NON-agent sessions are ever recorded as the return target. An agent
# session is one that contains a pane the sidebar has marked with @pane_status
# (its agent status). So while you sit in / switch between work sessions the
# target follows you, but the moment you dive into an agent it FREEZES -- and
# stays frozen no matter how many agents you hop between (select agent -> select
# another -> select another). That's what pins `prefix + Backspace` to the work
# session you started from.
#
# Origin is stored per client, keyed by the client's tty, in a global user
# option (@sborigin_<sanitized-tty>) holding a session id. We only ever use
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

# Agent session? True if any pane in it carries the sidebar's @pane_status
# marker. If so, leave the recorded origin frozen (we're diving / chaining).
if tmux list-panes -s -t "$arrived_sid" -F '#{@pane_status}' 2>/dev/null | grep -q .; then
  exit 0
fi

# Landed on a work session -> that's home. Record it for this client.
key="@sborigin_$(printf '%s' "$tty" | tr -c 'A-Za-z0-9' '_')"
tmux set -g "$key" "$arrived_sid"
exit 0
