set -euo pipefail
export PATH="@PATH@"

EXCLUDED='@EXCLUDED_JSON@'

ip4="$(
  ip -j -4 addr show scope global \
  | jq -r --argjson ex "$EXCLUDED" '
      .[]
      | select(.ifname as $n | ($ex | index($n) | not))
      | .addr_info[]?
      | select(.family=="inet")
      | .local
      | select(
          test("^10\\.")
          or test("^192\\.168\\.")
          or (test("^172\\.") and ((split(".")[1] | tonumber) >= 16 and (split(".")[1] | tonumber) <= 31))
        )
    ' \
  | head -n1
)"

if [ -n "${ip4:-}" ] && [ "${ip4:-null}" != "null" ]; then
  printf '{"text":"%s"}' "$ip4"
  exit 0
fi

exit 1
