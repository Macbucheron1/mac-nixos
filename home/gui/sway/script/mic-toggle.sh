#!/usr/bin/env bash

wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q '\[MUTED\]'; then
  notify-send "Microphone" "Micro coupé"
else
  notify-send "Microphone" "Micro actif"
fi

