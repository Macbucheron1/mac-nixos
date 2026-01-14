set -euo pipefail
export PATH="@PATH@"

EXCLUDED='@EXCLUDED_JSON@'
WHITELIST='["enp4s0","wlo1"]'

ip4="$(
  ip -j -4 addr show scope global \
  | jq -r --argjson ex "$EXCLUDED" --argjson wl "$WHITELIST" '
      [ .[]
        | select(.ifname as $n | ($ex | index($n) | not))
        | select(.ifname as $n | ($wl | index($n)) != null)
        | { ifname, addr: ( .addr_info[]? | select(.family=="inet") | .local ) }
      ]
      | sort_by(.ifname as $n | ($wl | index($n)))
      | .[]
      | .addr
      | select(
          test("^10\\.")
          or test("^192\\.168\\.")
          or (test("^172\\.") and ((split(".")[1] | tonumber) >= 16 and (split(".")[1] | tonumber) <= 31))
        )
    ' \
  | head -n1
)"

if [ -n "${ip4:-}" ] && [ "${ip4:-null}" != "null" ]; then
  rt="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
  flag="$rt/waybar-lan-copied"

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

exit 1

