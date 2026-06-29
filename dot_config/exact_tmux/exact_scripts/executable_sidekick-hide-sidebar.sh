#!/usr/bin/env bash
# Hide the tmux-agent-sidebar in a sidekick.nvim session once you navigate away
# from it, so the sidebar is ephemeral per sidekick session while sidebars in
# normal sessions persist.
#
# sidekick.nvim names its tmux sessions "sidekick|...". The agent-sidebar plugin
# marks its own pane with the tmux pane option @pane_role = "sidebar" and "hides"
# a sidebar by killing that pane (see tmux-agent-sidebar src/cli/toggle.rs); we
# do the same. Re-open it later with `prefix + e` while back in the session.
#
# Invoked from the client-session-changed hook with the session the client just
# LEFT (#{client_last_session}) as $1.
session="$1"

# Only act on the session that was left when it is a sidekick session. Leaving a
# normal session never touches its sidebar.
case "$session" in
  'sidekick|'*) ;;
  *) exit 0 ;;
esac

tmux list-panes -s -t "$session" -F '#{pane_id} #{@pane_role}' 2>/dev/null \
  | while read -r pane role; do
      [ "$role" = "sidebar" ] && tmux kill-pane -t "$pane" 2>/dev/null
    done

exit 0
