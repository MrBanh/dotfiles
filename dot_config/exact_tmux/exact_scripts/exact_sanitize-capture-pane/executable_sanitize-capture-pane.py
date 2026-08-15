#!/usr/bin/env python3
"""Transparent `tmux` shim that neutralizes shell metacharacters in
`capture-pane -e` output.

tmux-fzf-links runs `tmux capture-pane -e` to grab the pane, then interpolates
that (attacker-controlled) text unescaped into a shell-constructed
`echo "…" | fzf` command (fzf_handler.py). `$(…)`, backticks, and `"` in the
capture are expanded/handled by the shell, enabling code execution merely by
showing crafted content in a pane and pressing the plugin keybinding.

This shim intercepts only escaped-capture output and backslash-escapes dollar,
double-quote, backtick, and backslashes that sit directly in front of those
so that, inside the plugin's double-quoted echo, the bytes render identically
but carry no shell meaning. Everything else (all other tmux invocations) is
forwarded verbatim via exec.

Installation: put this file's directory in `@fzf-links-path-extension`,
so the plugin's `tmux` lookups hit the `tmux` symlink that points here:
    set -g @fzf-links-path-extension "$HOME/.config/tmux/scripts/sanitize-capture-pane"
"""

import os
import subprocess
import sys

WRAP_DIR = os.path.dirname(os.path.abspath(__file__))


def find_real_tmux() -> str:
    """Locate the real tmux binary, skipping this shim's own directory."""
    for directory in os.environ.get("PATH", "").split(":"):
        if not directory:
            directory = "."
        if os.path.abspath(directory) == WRAP_DIR:
            continue
        candidate = os.path.join(directory, "tmux")
        if os.access(candidate, os.X_OK):
            return candidate
    sys.stderr.write("tmux shim: could not find the real tmux binary\n")
    sys.exit(127)


def sanitize(data: bytes) -> bytes:
    """Neutralize bytes that are active inside the plugin's double-quoted echo.

    Inside the crafted ``echo "<content>" | fzf``:
      - ``$`` must be escaped to ``\\$`` or ``$(...)``/``$var`` would expand;
      - ``"`` must be escaped to ``\\"`` to stop the quoting from breaking out;
      - backtick must be escaped to ``\\` `` to stop command substitution;
      - a ``\\`` directly before ``$``, ``"`` or a backtick must be doubled to
        ``\\\\`` so ``\\$(...)`` cannot survive as ``\\`` + ``$(...)`` in the
        shell. Standalone backslashes (e.g. inside OSC 8 terminators) are left
        untouched so labels and URIs round-trip unchanged.
    """
    out = bytearray()
    i = 0
    n = len(data)
    while i < n:
        b = data[i]
        if b == 0x5C:  # backslash
            nxt = data[i + 1] if i + 1 < n else None
            if nxt in (0x24, 0x60, 0x22):  # $ ` "
                out.extend(b"\\\\")
            else:
                out.append(b)
            i += 1
        elif b in (0x24, 0x60, 0x22):  # $ ` "
            out.append(0x5C)
            out.append(b)
            i += 1
        else:
            out.append(b)
            i += 1
    return bytes(out)


def main() -> None:
    args = sys.argv[1:]
    real = find_real_tmux()

    is_capture_pane = bool(args) and args[0] == "capture-pane"
    wants_escapes = is_capture_pane and any(
        a == "-e"
        or (
            a.startswith("-")
            and not a.startswith("--")
            and "e" in a[1:]
        )
        for a in args
    )

    if not wants_escapes:
        os.execv(real, [real] + args)

    proc = subprocess.run([real] + args, capture_output=True)
    sys.stdout.buffer.write(sanitize(proc.stdout))
    sys.stderr.buffer.write(proc.stderr)
    sys.exit(proc.returncode)


if __name__ == "__main__":
    main()
