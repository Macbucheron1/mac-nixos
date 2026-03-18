set -euo pipefail
export PATH="@PATH@"

VPN_IFACES=(@VPN_IFACES@)

rt="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

get_ip() {
  local dev="$1"

  ip -j -4 addr show dev "$dev" scope global \
    | jq -r '.[0].addr_info[]? | select(.family=="inet") | .local' \
    | head -n1 || true
}

print_vpn() {
  local dev="$1"
  local ip4 flag cls

  if ! ip link show "$dev" >/dev/null 2>&1; then
    printf '{"text":"","class":""}'
    return 0
  fi

  ip4="$(get_ip "$dev")"
  if [ -z "${ip4:-}" ] || [ "${ip4:-null}" = "null" ]; then
    printf '{"text":"","class":""}'
    return 0
  fi

  flag="$rt/waybar-vpn-${dev}-copied"
  cls="vpn"
  if [ -f "$flag" ]; then
    now="$(date +%s%3N)"
    ts="$(cat "$flag" 2>/dev/null || echo 0)"
    if [ $((now - ts)) -lt 900 ]; then
      cls="$cls copied"
    fi
  fi

  printf '{"text":"%s","class":"%s"}' "$ip4" "$cls"
  return 0
}

if [ "${1:-}" != "" ]; then
  print_vpn "$1"
  exit 0
fi

for dev in "${VPN_IFACES[@]}"; do
  ip4="$(get_ip "$dev")"
  if [ -n "${ip4:-}" ] && [ "${ip4:-null}" != "null" ]; then
    print_vpn "$dev"
    exit 0
  fi
done

printf '{"text":"","class":""}'
