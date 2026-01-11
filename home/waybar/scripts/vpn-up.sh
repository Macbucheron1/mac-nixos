set -euo pipefail
export PATH="@PATH@"

VPN_IFACES=(@VPN_IFACES@)

for dev in "${VPN_IFACES[@]}"; do
  if ip link show "$dev" >/dev/null 2>&1; then
    exit 0
  fi
done

exit 1

