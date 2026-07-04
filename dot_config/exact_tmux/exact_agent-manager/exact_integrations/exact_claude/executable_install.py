#!/usr/bin/env python3
"""Idempotently wire agent-manager's Claude Code hooks into ~/.claude/settings.json.

Adds one command hook per event that records the pane's state via agent-state.sh:
    SessionStart, Stop        -> idle
    UserPromptSubmit, PreToolUse -> working
    Notification              -> waiting   (permission / needs input)

Only our own entries (identified by the MARKER path) are touched; every other
hook and setting is preserved. Nothing is written if there's no net change, and
an unparseable settings file is left completely untouched.

Usage: install.py /abs/path/to/integrations/claude/agent-state.sh
"""
import json
import os
import sys

SETTINGS = os.path.expanduser("~/.claude/settings.json")
# Stable tail present in our command whether it was stored as an absolute or a
# relative path — so is_ours() reliably finds (and de-dupes) our own entries.
MARKER = "integrations/claude/agent-state.sh"
EVENTS = {
    "SessionStart": "idle",
    "UserPromptSubmit": "working",
    "PreToolUse": "working",
    "Notification": "waiting",
    "Stop": "idle",
}


def is_ours(group):
    if not isinstance(group, dict):
        return False
    for hook in group.get("hooks", []) or []:
        if isinstance(hook, dict) and MARKER in str(hook.get("command", "")):
            return True
    return False


def main():
    if len(sys.argv) < 2:
        print("install.py: missing hook script path", file=sys.stderr)
        return 2
    # Always store an absolute command so hooks work regardless of claude's CWD
    # and so re-runs stay idempotent.
    script = os.path.abspath(sys.argv[1])

    data = {}
    if os.path.exists(SETTINGS):
        try:
            with open(SETTINGS, encoding="utf-8") as fh:
                text = fh.read()
            data = json.loads(text) if text.strip() else {}
        except Exception:
            print("claude: ~/.claude/settings.json is not valid JSON — leaving it untouched")
            return 0
        if not isinstance(data, dict):
            print("claude: unexpected settings.json shape — leaving it untouched")
            return 0

    before = json.dumps(data, sort_keys=True)

    hooks = data.setdefault("hooks", {})
    if not isinstance(hooks, dict):
        print("claude: settings.json 'hooks' is not an object — leaving it untouched")
        return 0

    for event, state in EVENTS.items():
        groups = [g for g in (hooks.get(event) or []) if not is_ours(g)]
        command = {"type": "command", "command": f"{script} {state}"}
        if event == "PreToolUse":
            groups.append({"matcher": "*", "hooks": [command]})
        else:
            groups.append({"hooks": [command]})
        hooks[event] = groups

    if json.dumps(data, sort_keys=True) == before:
        print("claude: hooks already up to date")
        return 0

    os.makedirs(os.path.dirname(SETTINGS), exist_ok=True)
    tmp = SETTINGS + ".agent-manager.tmp"
    with open(tmp, "w", encoding="utf-8") as fh:
        json.dump(data, fh, indent=2)
        fh.write("\n")
    os.replace(tmp, SETTINGS)
    print("claude: installed hooks -> ~/.claude/settings.json")
    return 0


if __name__ == "__main__":
    sys.exit(main())
