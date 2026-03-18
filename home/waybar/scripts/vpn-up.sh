set -euo pipefail
export PATH="@PATH@"

VPN_IFACES=(@VPN_IFACES@)

has_vpn_ip() {
  local dev="$1"

  if ! ip link show "$dev" >/dev/null 2>&1; then
    return 1
  fi

  ip -j -4 addr show dev "$dev" scope global \
    | jq -e '.[0].addr_info[]? | select(.family == "inet")' >/dev/null 2>&1
}

if [ "${1:-}" != "" ]; then
  if has_vpn_ip "$1"; then
    exit 0
  fi

  exit 1
fi

for dev in "${VPN_IFACES[@]}"; do
  if has_vpn_ip "$dev"; then
    exit 0
  fi
done

exit 1
