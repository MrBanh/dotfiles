#!/usr/bin/env bash
# Hide the agent sidebar everywhere EXCEPT the floating popup.
#
# Replaces the old sidekick-hide-sidebar.sh. The floating popup (prefix + e, see
# configs/04-plugins.conf) shows the sidebar and lets you jump into agents; while you
# browse there we keep the per-agent sidebar the plugin spawns alongside each
# agent (src/state/focus.rs) so you can hop between agents. But once you leave the
# popup and open that agent normally — e.g. via sidekick.nvim on your main client —
# that leftover sidebar pane should NOT be there. So whenever a normal client
# changes session, kill every sidebar pane outside the agent-sidebar list session.
#
# The popup client is exempt: it stamps its own tty into @sidebar_popup_tty (set
# while open, cleared on close). We skip the sweep when the client that changed is
# that popup — otherwise resuming or navigating agents inside the popup would kill
# the very sidebar it is showing. The popup re-adds the sidebar on resume, so the
# ping-pong (hidden on main, shown in popup) stays consistent.
#
# $1 = #{client_tty} of the client whose attached session just changed (from the
# client-session-changed hook).
changed_tty="$1"
popup_tty="$(tmux show -gv @sidebar_popup_tty 2>/dev/null)"

# Inside the floating popup: leave every sidebar alone.
[ -n "$popup_tty" ] && [ "$changed_tty" = "$popup_tty" ] && exit 0

# Normal client navigating: kill sidebar panes (marked @pane_role=sidebar by the
# plugin's toggle) outside the floating list session. Emit "<pane_id>
# <session_name>" only for sidebar-role panes; pane_id has no spaces, so the
# session name (which may contain spaces or a "sidekick|" prefix) soaks up the
# rest of the line.
tmux list-panes -a -F \
  '#{?#{==:#{@pane_role},sidebar},#{pane_id} #{session_name},}' 2>/dev/null \
  | while read -r pane session; do
      [ -n "$pane" ] || continue
      [ "$session" = agent-sidebar ] && continue
      tmux kill-pane -t "$pane" 2>/dev/null
    done

exit 0
