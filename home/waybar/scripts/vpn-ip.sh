set -euo pipefail
export PATH="@PATH@"

VPN_IFACES=(@VPN_IFACES@)

for dev in "${VPN_IFACES[@]}"; do
  if ip link show "$dev" >/dev/null 2>&1; then
    ip4="$(
      ip -j -4 addr show dev "$dev" scope global \
        | jq -r '.[0].addr_info[]? | select(.family=="inet") | .local' \
        | head -n1 || true
    )"

    if [ -n "${ip4:-}" ] && [ "${ip4:-null}" != "null" ]; then
      printf '{"text":"%s"}' "$ip4"
      exit 0
    fi

    # iface existe mais pas d'IP => vide
    printf '{"text":""}'
    exit 0
  fi
done

printf '{"text":""}'

