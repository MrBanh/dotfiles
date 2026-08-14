#!/usr/bin/env bash
# `prefix + Backspace`: jump this client back to the work session it was in
# before selecting an agent in workmux (its sidebar or picker). The return target
# is recorded per client by workmux-return-track.sh (see 03-hooks.conf).
#
# Args: $1 = client tty (#{client_tty})

tty="$1"
[ -n "$tty" ] || exit 0

key="@workmux_origin_$(printf '%s' "$tty" | tr -c 'A-Za-z0-9' '_')"
origin="$(tmux show -gv "$key" 2>/dev/null)"
[ -n "$origin" ] || exit 0

# Target the pressing client explicitly by its tty (the same client whose origin
# we looked up), and the destination by session id -- both unambiguous targets.
tmux switch-client -c "$tty" -t "$origin" 2>/dev/null
