#!/usr/bin/env bash

case "$1" in
    up) brightnessctl set 5%+ > /dev/null ;;
    down) brightnessctl set 5%- > /dev/null ;;
esac

max=$(brightnessctl max)
current=$(brightnessctl get)
percent=$((current * 100 / max))

notify-send -u low "Brightness" "${percent}%"
