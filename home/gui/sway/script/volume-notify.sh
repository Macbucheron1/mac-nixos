#!/usr/bin/env bash
set -eu

SINK_ID="51"
STEP="5%"

case "${1:-}" in
  up)   wpctl set-volume "$SINK_ID" "${STEP}+" ;;
  down) wpctl set-volume "$SINK_ID" "${STEP}-" ;;
  mute) wpctl set-mute   "$SINK_ID" toggle ;;
  *) exit 0 ;;
esac

info="$(wpctl get-volume "$SINK_ID")"
vol="$(echo "$info" | awk '{print $2}' | sed 's/[^0-9.].*//')"
pct="$(awk "BEGIN { printf \"%d\", ($vol * 100) }")"

if echo "$info" | grep -q '\[MUTED\]'; then
  notify-send -u low "Volume" "Muted"
else
  notify-send -u low "Volume" "${pct}%"
fi

