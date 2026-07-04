#!/usr/bin/env bash
# agent-manager entrypoint. Load from your tmux config with:
#   run-shell "~/.config/tmux/agent-manager/agent-manager.tmux"
#
# This only binds the popup key (override via @agent_manager_key, default: e).
# It deliberately does NOT touch your agent configs on every load — run
# `agent-manager install` once to wire up live status (see README). That keeps us
# from rewriting an externally-managed ~/.claude/settings.json behind your back.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$DIR/bin/agent-manager"

tmux set -g @agent_manager_bin "$BIN"

key="$(tmux show -gv @agent_manager_key 2>/dev/null)"
[ -n "$key" ] || key="e"
# Pass the pressing client's name so cmd_menu can target its popup and, on ctrl-e,
# switch that exact client to the agent window. `|| true` so tmux never flashes
# "... menu returned N" when you cancel the picker (fzf exits 130) or tear down a view.
tmux bind-key "$key" run-shell "$BIN menu '#{client_name}' || true"

# Back key: from inside an agent view popup, jump straight back to the picker.
# It's a global binding but a no-op unless the pressing client is in the view, so it
# behaves as if it only exists inside the popup. Override via @agent_manager_back_key.
backkey="$(tmux show -gv @agent_manager_back_key 2>/dev/null)"
[ -n "$backkey" ] || backkey="BSpace"
tmux bind-key "$backkey" run-shell "$BIN back '#{client_name}' || true"
