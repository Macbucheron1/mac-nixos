#!/usr/bin/env bash

case "$1" in
    up) pw-volume change +5% ;;
    down) pw-volume change -5% ;;
    mute) pw-volume mute toggle ;;
esac

# Get volume info
info=$(pw-volume status)
volume=$(echo "$info" | grep -oP '\d+' | head -1)

if echo "$info" | grep -q 'muted'; then
    notify-send -u low "Volume" "Muted"
else
    notify-send -u low "Volume" "${volume}%"
fi
