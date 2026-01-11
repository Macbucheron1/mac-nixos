set -euo pipefail
export PATH="@PATH@"

VPN_IFACES=(@VPN_IFACES@)

rt="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
flag="$rt/waybar-vpn-copied"

for dev in "${VPN_IFACES[@]}"; do
  if ip link show "$dev" >/dev/null 2>&1; then
    ip4="$(
      ip -j -4 addr show dev "$dev" scope global \
        | jq -r '.[0].addr_info[]? | select(.family=="inet") | .local' \
        | head -n1 || true
    )"

    if [ -n "${ip4:-}" ] && [ "${ip4:-null}" != "null" ]; then
      cls=""
      if [ -f "$flag" ]; then
        now="$(date +%s%3N)"
        ts="$(cat "$flag" 2>/dev/null || echo 0)"
        if [ $((now - ts)) -lt 900 ]; then
          cls="copied"
        fi
      fi

      printf '{"text":"%s","class":"%s"}' "$ip4" "$cls"
      exit 0
    fi

    printf '{"text":"","class":""}'
    exit 0
  fi
done

printf '{"text":"","class":""}'

