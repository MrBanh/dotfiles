#!/usr/bin/env bash
# Track a per-client "return session" so `prefix + Backspace` can jump back to
# where you were before you selected an agent in ccmux (its sidebar or picker).
# Wired to the client-session-changed and client-attached hooks (see
# 03-hooks.conf), which pass the client's tty.
#
# Rule: only NON-agent sessions are ever recorded as the return target. ccmux
# tracks each agent in its own tmux session whose name is prefixed "sidekick|"
# (e.g. "sidekick|opencode d85803d2  my-repo"); selecting one runs
# `tmux switch-client -t <agent-pane>`, moving this client into that session. So
# while you sit in / switch between work sessions the target follows you, but the
# moment you land on an agent session it FREEZES -- and stays frozen no matter
# how many agents you hop between (select agent -> select another -> another).
# That's what pins `prefix + Backspace` to the work session you started from.
#
# Origin is stored per client, keyed by the client's tty, in a global user
# option (@ccmux_origin_<sanitized-tty>) holding a session id. We only ever use
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

# Agent session? True if its name carries ccmux's "sidekick|" prefix. If so,
# leave the recorded origin frozen (we're diving into / chaining agents).
arrived_name="$(tmux display-message -t "$tty" -p '#{session_name}' 2>/dev/null)"
case "$arrived_name" in
  'sidekick|'*) exit 0 ;;
esac

# Landed on a work session -> that's home. Record it for this client.
key="@ccmux_origin_$(printf '%s' "$tty" | tr -c 'A-Za-z0-9' '_')"
tmux set -g "$key" "$arrived_sid"
exit 0
