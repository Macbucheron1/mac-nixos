#!/usr/bin/env bash
set -euo pipefail
export PATH="@PATH@"

tree="$(swaymsg -t get_tree)"

pid="$(printf '%s\n' "$tree" \
  | jq -r '.. | select(.focused? == true) | .pid // empty' \
  | head -n1)"

has_zellij="no"

if [ -n "$pid" ]; then
  if pstree -p "$pid" | grep -q 'zellij('; then
    has_zellij="yes"
  fi
fi

if [ "$has_zellij" = "yes" ]; then
  exec wtype -M ctrl -k y -m ctrl
fi

tmpfile="$(mktemp)"
trap 'rm -f "$tmpfile"' EXIT

foot \
  -a clipboard-picker \
  -T clipboard-picker \
  -e bash -c '
    cliphist list \
      | fzf --layout=reverse --border > "$1"
  ' _ "$tmpfile"

selection="$(cat "$tmpfile" || true)"
[ -n "$selection" ] || exit 0

printf '%s' "$selection" \
  | cliphist decode \
  | wl-copy
