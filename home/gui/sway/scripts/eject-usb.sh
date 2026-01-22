# --- Vibecoded do not touch ---
#!/usr/bin/env bash
set -euo pipefail
export PATH="@PATH@"

ROFI_CMD=${ROFI_CMD:-"rofi -dmenu -i -p 'Eject external'"}
USER_NAME="${USER}"
MEDIA_PREFIX="/run/media/${USER_NAME}/"

# Disque qui contient /  (pour ne jamais proposer le disque système)
ROOT_SRC="$(findmnt -n -o SOURCE / || true)"
ROOT_DISK="$(lsblk -no PKNAME "$ROOT_SRC" 2>/dev/null || true)"
if [ -z "${ROOT_DISK:-}" ] && [[ "${ROOT_SRC:-}" =~ ^/dev/ ]]; then
  ROOT_DISK="$(basename "$ROOT_SRC" | sed -E 's/p?[0-9]+$//')"
fi

DISK_ICON=""

JSON="$(lsblk -J -o NAME,PATH,TYPE,FSTYPE,LABEL,MOUNTPOINT,SIZE,TRAN,RM,HOTPLUG)"

MENU="$(
  echo "$JSON" | jq -r --arg mpref "$MEDIA_PREFIX" --arg rootdisk "${ROOT_DISK:-}" --arg icon "$DISK_ICON" '
    def is_external:
      ((.rm // 0) == 1) or ((.hotplug // 0) == 1) or ((.tran // "") == "usb");

    def mountpoints_under_media($disk):
      [ ($disk.children? // [])
        | .. | objects
        | select(.mountpoint? != null and (.mountpoint | startswith($mpref)))
        | .mountpoint
      ] | unique;

    .blockdevices[]
    | select(.type == "disk")
    | select(is_external)
    | select(.name != $rootdisk)
    | . as $d
    | (mountpoints_under_media($d)) as $mps
    | if ($mps | length) > 0 then
        # Une seule ligne par disque, même si plusieurs partitions montées
        ($icon + "   " + "\($d.label // $d.name) (\($d.size))  — lock+eject\t" + ($mps | join("::")))
      else
        # Disque externe branché mais rien monté : on propose quand même l’éjection
        "\($d.label // $d.name) (\($d.size))  — eject\tDEV:\($d.path)"
      end
  '
)"

[ -n "${MENU:-}" ] || exit 0

CHOICE="$(printf '%s\n' "$MENU" | $ROFI_CMD)"
[ -n "${CHOICE:-}" ] || exit 0

TARGET="$(printf '%s' "$CHOICE" | awk -F'\t' '{print $2}')"
[ -n "${TARGET:-}" ] || exit 0

# Cas 1 : on a des mountpoints => udiskie fait unmount + lock + detach
if [[ "$TARGET" != DEV:* ]]; then
  IFS='::' read -r -a MPS <<< "$TARGET"
  # --detach = détache le drive
  # --lock = par défaut (donc re-chiffre / re-lock après unmount)
  # --force = pratique si plusieurs sous-mounts
  # (voir man udiskie-umount) :contentReference[oaicite:1]{index=1}
  udiskie-umount --force --detach "${MPS[@]}"
  notify-send "Disk" "Lock + eject OK" || true
  exit 0
fi

# Cas 2 : rien monté => éjection simple (safe remove)
DEV="${TARGET#DEV:}"
udisksctl power-off -b "$DEV"
notify-send "Disk" "Eject OK: $DEV" || true

