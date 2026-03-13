#!/usr/bin/env bash
set -euo pipefail
export PATH="@PATH@"

choice="$(
  printf '%s\n' \
    "off" \
    "transparency" \
    "nc" \
    "adaptive" \
  | rofi -dmenu -i -p 'AirPods mode'
)"

case "${choice:-}" in
  "")
    exit 0
    ;;
  off|transparency|nc|adaptive)
    exec vibepods-cli mode "$choice"
    ;;
  *)
    exit 1
    ;;
esac
