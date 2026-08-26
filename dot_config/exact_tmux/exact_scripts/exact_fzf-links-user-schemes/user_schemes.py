"""User schemes for tmux-fzf-links.

Ghost-path scheme: surfaces path-like tokens (absolute, ~/ or ./ prefixed)
that do NOT exist on disk. The default `file` scheme silently drops these
(its pre-handler requires Path.exists()), which hides paths that a terminal
transcript merely *mentions* — e.g. files listed by an `rm` that already ran.

Ghost entries are copy-only: selecting one copies the path to the tmux
buffer (and system clipboard via tmux's -w) instead of trying to open it.
Existing paths return None here so the default file/dir scheme handles them
(open in editor / cd) exactly as before.
"""

import os
import re

from tmux_fzf_links.export import OpenerType, PostHandledMatch, PreHandledMatch, SchemeEntry, configs, colors


# >>> GHOST PATH SCHEME >>>

# Path-like token starting with /, ~/ , ./ or ../ . The lookbehind rejects
# matches inside URLs (`https:`/`:` before the slash) and mid-word slashes.
# The final character class keeps trailing punctuation (`)`, `,`, `.`) out of
# the match so copyable text is clean.
_ghost_regex = re.compile(
    r"(?<![\w:/.@-])"
    r"(?P<path>(?:~/|\./|\.\./|/)(?:[\w.@+-]+/)*[\w.@+-]*|(?<=\.\./)\.\.)"
)

def ghost_pre_handler(match: re.Match[str]) -> PreHandledMatch | None:
    path: str = match.group("path")

    if len(path.encode("utf-8")) > configs.max_path_length:
        return None

    # Drop matches containing only `.` or `~` fragments
    if all(char in ".~" for char in path):
        return None

    # Existing paths: defer to the default file scheme (open / cd)
    if os.path.exists(os.path.expanduser(path)):
        return None

    display_text = f"{colors.dim_color}{path}{colors.reset_color}"

    return {"display_text": display_text, "tag": "ghost"}

def ghost_post_handler(match: re.Match[str]) -> PostHandledMatch:
    # Nothing to open — copy the path instead
    path = match.group("path")
    return {
        "cmd": "tmux",
        "args": [
            "set-buffer",
            "-w",
            f"{path}",
            ";",
            "display-message",
            f"path '{path}' copied to tmux buffer (does not exist on disk)",
        ],
    }

ghost_scheme: SchemeEntry = {
    "tags": ("ghost",),
    "opener": OpenerType.CUSTOM_OPEN,
    "post_handler": ghost_post_handler,
    "pre_handler": ghost_pre_handler,
    "regex": [_ghost_regex],
}

# <<< GHOST PATH SCHEME <<<


user_schemes: list[SchemeEntry] = [
    ghost_scheme,
]

rm_default_schemes: list[str] = []

__all__ = ["user_schemes", "rm_default_schemes"]
