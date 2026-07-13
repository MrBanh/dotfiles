#!/usr/bin/env sh
# Merge the matugen-generated [palettes.matugen] block into starship.toml.
#
# starship has no include mechanism, so the palette must live inline in the
# real config. This script keeps ONLY that palette in sync: it copies the
# [palettes.matugen] section out of the generated file and swaps it into the
# target between two delimiter comments, leaving everything else untouched.
#
# Delimiters (must match the markers already present in starship.toml):
#   # >>> matugen palette (managed by matugen post_hook; do not edit) >>>
#   ... palette ...
#   # <<< matugen palette <<<
#
# If the markers are missing (e.g. first run), it falls back to replacing the
# bare [palettes.matugen] section in place and wraps it in markers so future
# runs are marker-based. If there's no palette at all, the block is appended.
#
# Uses only POSIX sh + awk — no third-party packages.
#
# Usage:
#   merge-starship-palette.sh [GENERATED] [TARGET]
# Defaults:
#   GENERATED = ~/.config/starship/matugen.toml
#   TARGET    = ~/.config/starship/starship.toml
set -eu

GENERATED="${1:-$HOME/.config/starship/matugen.toml}"
TARGET="${2:-$HOME/.config/starship/starship.toml}"

BEGIN_MARK="# >>> matugen palette (managed by matugen post_hook; do not edit) >>>"
END_MARK="# <<< matugen palette <<<"

[ -f "$GENERATED" ] || { echo "merge-starship-palette: generated file not found: $GENERATED" >&2; exit 1; }
[ -f "$TARGET" ]    || { echo "merge-starship-palette: target file not found: $TARGET" >&2; exit 1; }

PAL_TMP="$(mktemp)"
OUT_TMP="$(mktemp)"
trap 'rm -f "$PAL_TMP" "$OUT_TMP"' EXIT INT TERM

# 1) Extract just the [palettes.matugen] section from the generated file:
#    start at its header, stop at the next section header (or EOF).
awk '
  /^\[palettes\.matugen\]/ { grab=1; print; next }
  grab && /^\[/            { exit }
  grab                     { print }
' "$GENERATED" >"$PAL_TMP"

[ -s "$PAL_TMP" ] || { echo "merge-starship-palette: no [palettes.matugen] block in $GENERATED" >&2; exit 1; }

# 2) Rewrite the target, replacing the delimited block with the fresh palette.
awk -v begin="$BEGIN_MARK" -v end="$END_MARK" -v palfile="$PAL_TMP" '
  function emit(   line) {
    print begin
    while ((getline line < palfile) > 0) print line
    close(palfile)
    print end
  }

  # Preferred path: markers already exist -> replace what is between them.
  $0 == begin { emit(); skip=1; replaced=1; next }
  skip        { if ($0 == end) skip=0; next }

  # Fallback: no markers yet -> replace the bare [palettes.matugen] section
  # once, then wrap it in markers for next time.
  !replaced && /^\[palettes\.matugen\]/ { emit(); dropsec=1; replaced=1; next }
  dropsec { if (/^\[/) { dropsec=0; print } next }

  { print }

  END { if (!replaced) { print ""; emit() } }  # nothing found -> append
' "$TARGET" >"$OUT_TMP"

# 3) Move into place only if something changed (keeps mtime stable otherwise).
if cmp -s "$OUT_TMP" "$TARGET"; then
  exit 0
fi
cat "$OUT_TMP" >"$TARGET"
echo "merge-starship-palette: updated $TARGET"
