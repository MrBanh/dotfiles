#!/usr/bin/env sh
# Generate theme files from config.toml using matugen.
#
# matugen has no built-in "render one template" flag — it renders every [templates.*]
# in the config it's given. To generate a SUBSET, this script builds a temp config
# (inside this dir, so relative paths in config.toml still resolve) containing
# [config] + only the requested [templates.*] blocks.
#
# Usage:
#   ./apply.sh                    # generate ALL tools
#   ./apply.sh opencode           # generate ONLY opencode
#   ./apply.sh opencode delta     # generate a subset
#   ./apply.sh --list             # list available template names
#   ./apply.sh -- --dry-run       # pass extra flags to matugen after `--`
#   ./apply.sh opencode -- -v     # subset + matugen flags
#
# Note: requesting "yazi" also regenerates its "yazi-tmtheme" sidecar.
set -eu

DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
CONFIG="$DIR/config.toml"
SEED="#83c092" # required by matugen but unused; templates read only imported colors

names=""
passthrough=""
after=0
for a in "$@"; do
  if [ "$after" = 1 ]; then
    passthrough="$passthrough $a"
    continue
  fi
  case "$a" in
    --) after=1 ;;
    --list)
      grep -oE '^\[templates\.[^]]+\]' "$CONFIG" | sed 's/^\[templates\.//; s/\]$//'
      exit 0
      ;;
    -*)
      passthrough="$passthrough $a"
      after=1
      ;;
    *) names="$names $a" ;;
  esac
done

# No template names -> render the full config.
if [ -z "${names# }" ]; then
  # shellcheck disable=SC2086
  exec matugen -c "$CONFIG" $passthrough color hex "$SEED" -m dark
fi

# Convenience: "yazi" implies its tmtheme sidecar.
case " $names " in
  *" yazi "*) case " $names " in *" yazi-tmtheme "*) : ;; *) names="$names yazi-tmtheme" ;; esac ;;
esac

tmp="$DIR/.matugen-subset.toml"
trap 'rm -f "$tmp"' EXIT INT TERM

# 1) Copy the [config] section (from [config] up to the first [templates.*]).
awk '
  /^\[config\]/ {flag=1}
  /^\[templates\./ {flag=0}
  flag {print}
' "$CONFIG" >"$tmp"

# 2) Append each requested [templates.NAME] block verbatim.
for n in $names; do
  if ! grep -qE "^\[templates\.$n\]$" "$CONFIG"; then
    echo "apply.sh: unknown template '$n' (try: ./apply.sh --list)" >&2
    exit 1
  fi
  printf '\n' >>"$tmp"
  awk -v want="[templates.$n]" '
    $0 == want {flag=1; print; next}
    /^\[/ && flag {flag=0}
    flag {print}
  ' "$CONFIG" >>"$tmp"
done

# shellcheck disable=SC2086
matugen -c "$tmp" $passthrough color hex "$SEED" -m dark
