#!/usr/bin/env bash
set -eu

SINK="@DEFAULT_AUDIO_SINK@"
STEP="5%"

case "${1:-}" in
  up)   wpctl set-volume "$SINK" "${STEP}+" ;;
  down) wpctl set-volume "$SINK" "${STEP}-" ;;
  mute) wpctl set-mute   "$SINK" toggle ;;
  *) exit 0 ;;
esac

info="$(wpctl get-volume "$SINK")"
vol="$(echo "$info" | awk '{print $2}' | sed 's/[^0-9.].*//')"
pct="$(awk "BEGIN { printf \"%d\", ($vol * 100) }")"

if echo "$info" | grep -q '\[MUTED\]'; then
  notify-send -u low "Volume" "Muted"
else
  notify-send -u low "Volume" "${pct}%"
fi

